Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B7234EF19;
	Fri, 21 Nov 2025 13:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733473; cv=none; b=unnSnB7WxehaeeftjTEuYeUcRkK/hugl/AhBuR22oLmBMCpiWEEHefThuGT1LTo315z4Yepa2W1dsO5HLwzYdpAhsC7RxeuGUx6ewZn0m3Bri0CsYyfTImStDb1mQrtzcSX1M9pOGkIF3hEJV9t8maxKIxEbfth11IR0d3aMcOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733473; c=relaxed/simple;
	bh=P4B8AHmC+0ohoEz++pwk7P3pkeDat9f1GZso9QI2yiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdmaX1A47c8eJq7ve2pPVUL95i92IMfT3ZeRBjfgnkgxpmLlDk4o2wOeeinT4sARsnny9nCrg6Qc2ayE1SRlra/kK8JdsYGGClhUvcbf+Hlb14KVQN7w7fpHOFJd2M9x4m4K6pYdyjz5YTrjVmEk7/cdHGwJ3+NTXXrkHJ/M6i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbUPss6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbUPss6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FC8C4CEF1;
	Fri, 21 Nov 2025 13:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733471;
	bh=P4B8AHmC+0ohoEz++pwk7P3pkeDat9f1GZso9QI2yiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbUPss6roqvUIznliRWlE699Ckn+pVOEN/mYzkZYygJZ0zvb/7m0wYVSZ1yjrB4/Y
	 q6NM2u+8vuakKGne6ylmQzJ2h7C0J5oN7BXSOYorbAgjQUXtEE6ucUB4jfBUKbsdBJ
	 QAE3Gq1yIbII+BLd0xR6zri366bBwVmWI7Fa9VSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 479/529] smb: client: fix cifs_pick_channel when channel needs reconnect
Date: Fri, 21 Nov 2025 14:12:58 +0100
Message-ID: <20251121130248.052492389@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit 79280191c2fd7f24899bbd640003b5389d3c109c upstream.

cifs_pick_channel iterates candidate channels using cur. The
reconnect-state test mistakenly used a different variable.

This checked the wrong slot and would cause us to skip a healthy channel
and to dispatch on one that needs reconnect, occasionally failing
operations when a channel was down.

Fix by replacing for the correct variable.

Fixes: fc43a8ac396d ("cifs: cifs_pick_channel should try selecting active channels")
Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1046,7 +1046,7 @@ struct TCP_Server_Info *cifs_pick_channe
 		if (!server || server->terminate)
 			continue;
 
-		if (CIFS_CHAN_NEEDS_RECONNECT(ses, i))
+		if (CIFS_CHAN_NEEDS_RECONNECT(ses, cur))
 			continue;
 
 		/*


