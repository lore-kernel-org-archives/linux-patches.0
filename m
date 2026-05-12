Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373633955C7;
	Tue, 12 May 2026 17:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608624; cv=none; b=EWEp9DB03c77WzsMwI6nYUlHrCOTkBwfBPK8abmiLO28CtVCIO8rwr+Y6jDiu/A3uwlsoXNcEEi//HEscCeM1Heu3F1lynuS8zn6Dk4pZ6X7Ch3TUVu4g+//nR3dUulafuV+lt8Q9aa8mQgPXd680XTgjth9xvazlwduLj0lyJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608624; c=relaxed/simple;
	bh=LK0bafdQWQqm8xpLjBhZfmZPa5Ns5/c1d5wH5Aglclg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCA771yDuP9UDnzJcvhHQ/Oe5F4X/1Z1qCLG587OIlAOqr1DJkBbXp5Irgg3a4FqPxUI113iw4D3A5f7qmcl5pFp148nY2yuf+1FeER/g7NxjIw06lyVmgBfHsCmV/G3zSvsvqSTWQcqBfhOrMT1AM1LF1EJv8sUt3SJB1PmTQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kql08vOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kql08vOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DE8C2BCB0;
	Tue, 12 May 2026 17:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608623;
	bh=LK0bafdQWQqm8xpLjBhZfmZPa5Ns5/c1d5wH5Aglclg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kql08vOk82UQZaL0M6v/9335TEkCrnMi5Glc1uSf/L5z33AawZ8R/rc8GutysRuBb
	 iYuItBmxq7nwGehPHkkFl/Aig9CbI9OlF0JpgtxTPlV3nfAKwHhklocTgey9yyMwIc
	 7sqh5+u7SJpZKIcYtdyGeDb+QjY7py26x0BAfDDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dexuan Cui <decui@microsoft.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 124/270] hv_sock: Return -EIO for malformed/short packets
Date: Tue, 12 May 2026 19:38:45 +0200
Message-ID: <20260512173941.066421955@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dexuan Cui <decui@microsoft.com>

commit 3d1f20727a635811f6b77801a7b57b8995268abd upstream.

Commit f63152958994 fixes a regression, however it fails to report an
error for malformed/short packets -- normally we should never see such
packets, but let's report an error for them just in case.

Fixes: f63152958994 ("hv_sock: Report EOF instead of -EIO for FIN")
Cc: stable@vger.kernel.org
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Acked-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260423064811.1371749-1-decui@microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/hyperv_transport.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -704,17 +704,26 @@ static s64 hvs_stream_has_data(struct vs
 		if (hvs->recv_desc) {
 			/* Here hvs->recv_data_len is 0, so hvs->recv_desc must
 			 * be NULL unless it points to the 0-byte-payload FIN
-			 * packet: see hvs_update_recv_data().
+			 * packet or a malformed/short packet: see
+			 * hvs_update_recv_data().
 			 *
-			 * Here all the payload has been dequeued, but
-			 * hvs_channel_readable_payload() still returns 1,
-			 * because the VMBus ringbuffer's read_index is not
-			 * updated for the FIN packet: hvs_stream_dequeue() ->
-			 * hv_pkt_iter_next() updates the cached priv_read_index
-			 * but has no opportunity to update the read_index in
-			 * hv_pkt_iter_close() as hvs_stream_has_data() returns
-			 * 0 for the FIN packet, so it won't get dequeued.
+			 * If hvs->recv_desc points to the FIN packet, here all
+			 * the payload has been dequeued and the peer_shutdown
+			 * flag is set, but hvs_channel_readable_payload() still
+			 * returns 1, because the VMBus ringbuffer's read_index
+			 * is not updated for the FIN packet:
+			 * hvs_stream_dequeue() -> hv_pkt_iter_next() updates
+			 * the cached priv_read_index but has no opportunity to
+			 * update the read_index in hv_pkt_iter_close() as
+			 * hvs_stream_has_data() returns 0 for the FIN packet,
+			 * so it won't get dequeued.
+			 *
+			 * In case hvs->recv_desc points to a malformed/short
+			 * packet, return -EIO.
 			 */
+			if (!(vsk->peer_shutdown & SEND_SHUTDOWN))
+				return -EIO;
+
 			return 0;
 		}
 


