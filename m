Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AC835C6B2;
	Sat, 12 Sep 2026 09:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204540; cv=none; b=jqHW26mFO62id8eCrbmpPPmVf1xsXRnRvto90Y1eC96InWI/g3g0NMOMs41TPshmyPzwnyBRLAzbdMDJ3qso1d+Oox0D95ITLCtCBR5Nys8j4HIEGyA5y/6iiatti2GSGhVDJnGWp5E3w0V36CpgMrS+JQmK9hcUqU+JFA87MC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204540; c=relaxed/simple;
	bh=/zcNrkRcd1G6pZkEyr5uHFcuuBC4IQ+UKXmfS+yG2JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xd4p009gZpbivmsku1j38QSrgSN9i1HmUKP6hg7ckGajV60aNhHIwtNBBZ2BFYhRINtBZrziLTdIaCIrXhC9g71erxoyfHkAThpSAavQQmc9QURcSM1AdP5ls6uOIIUr0OE0imvVWA9lzlzOeg/FNhGBfoIQEDLlzMhbyENs2V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYTTVBKt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYTTVBKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0488A1F00893;
	Sat, 12 Sep 2026 09:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204536;
	bh=exiQGV6i9NymqXb3Q7n7b6XrYe0e3Z3gdslktDcelbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYTTVBKtc0q7xh5xvyZfTqUZIIYDHE7VDChowcZx4P3s4I1JFVbm0O51fkK1TYJu+
	 Sq9pz9mrSfKIxap3UGXboqB7sUQyX4LyGWbC+Qqg+ELYku24J89zHzyLng563r9Bmd
	 mPCGFHmTO5pjHkRvtF16H7R76nImi/URaHkJ53aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Lusk <clusk@northecho.dev>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1632/1815] smb: client: set replay flag on the read send-error retry path
Date: Sat, 12 Sep 2026 08:56:22 +0200
Message-ID: <20260912065727.302145513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Lusk <clusk@northecho.dev>

[ Upstream commit 45f84cf25a0879a4d4e3ec3079982537be57c564 ]

smb2_async_readv() and smb2_async_writev() end with the same
send-error block: if the error is replayable and smb2_should_replay()
agrees, tell netfs to retry the subrequest. The write path also sets
wdata->replay. The read path does not set rdata->replay.

smb2_should_replay() is not a pure predicate. It consumes the retry
budget and computes the exponential back-off, doubling cur_sleep up to
CIFS_MAX_SLEEP. That back-off is only applied where the replay flag is
tested at the top of the reissued request:

	if (rdata->replay) {
		/* Back-off before retry */
		if (rdata->cur_sleep)
			msleep(rdata->cur_sleep);
		smb2_set_replay(server, &rqst);
	}

So on the read path the back-off is recomputed on every send-error
retry and then discarded, and SMB2_FLAGS_REPLAY_OPERATION is not set
on the reissued request.

netfs does not pace the retry either. netfs_reissue_read() calls
->issue_read() directly, and fs/netfs/read_retry.c contains no delay
of its own, so read send-error retries reissue immediately while the
equivalent write retries back off.

The read response callback already sets rdata->replay under the same
conditions, so the read path does use the replay mechanism. Only this
send-error path omits it.

Where the back-off belongs was settled while the commit below was
under review. David Howells asked whether netfslib should be doing the
back-off [1], and objected to sleeping inside the response callback
because that runs in the cifsd thread and would stall the socket [2].
The sleep was therefore taken out of smb2_should_replay() and moved to
just before the replay in smb2_async_readv() and smb2_async_writev()
[3]. Setting the flag here preserves that arrangement: the sleep still
happens at the top of the reissued request, not in a callback.

Set rdata->replay here, matching smb2_async_writev().

Fixes: 2c1238a7477a ("cifs: make retry logic in read/write path consistent with other paths")
Link: https://lore.kernel.org/all/1652858.1769038134@warthog.procyon.org.uk/ [1]
Link: https://lore.kernel.org/all/1653031.1769038583@warthog.procyon.org.uk/ [2]
Link: https://lore.kernel.org/all/CANT5p=pXP3+CywpmK-on2uTvxO3S=31_B85_UDR7RoK1dQVtMA@mail.gmail.com/ [3]
Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-5
Signed-off-by: Christopher Lusk <clusk@northecho.dev>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b885060be2004..d207591cc889c 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4893,6 +4893,7 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 	    smb2_should_replay(tcon,
 			       &rdata->retries,
 			       &rdata->cur_sleep)) {
+		rdata->replay = true;
 		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_retry_needed);
 		__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
 	}
-- 
2.53.0



