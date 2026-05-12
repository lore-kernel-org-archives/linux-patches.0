Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F6B3EDE45;
	Tue, 12 May 2026 18:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609311; cv=none; b=FhRyucv+q0uQ7sk1m8bk709G6A+MLtErqCQt9m4rcaMf57I5ZmtzgHEyd6iKQUQCCKBSf05cJ5/VMbXdIiRdP3CiA+/Vrd3+iKWDhIzgpW7KJEXwV8R+8AeAIr9g1cbSivyJXNM8DUI73YTTNTjh0uo8hYygV8L2UUQwG/YMGFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609311; c=relaxed/simple;
	bh=ncR1COdeWTOuTAg6qF9NbMt1EQoqzsnaxSwv8MGSEic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldIw5i3a1PzpvoxiTql9T8zdV3S+kJllqYZKzJeIr1qufzAqxJXfMHEiztumOXNTapp0XLLWGqwBfDn5CSorjxH1XAJYDf+RkHfaHrB1W//IzSJN+GYk2uStxlYQG6eM0ySushdkI8QMAh8ajWFYQQv6nemBDwS3YpWZb0gw38c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wx4jGXyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wx4jGXyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFD2C2BCB0;
	Tue, 12 May 2026 18:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609310;
	bh=ncR1COdeWTOuTAg6qF9NbMt1EQoqzsnaxSwv8MGSEic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wx4jGXyCOC2BUx8/vQLcxF16Vj5hSVIfZt173gmOVTZuu8kAvQBDsFoim2p5uFvoh
	 HOT9AKcgiFQQRG1KF7/w0Nzni+aLPBa3StxNvT6erwzb4EFH9uYq+ZzGZK0RIsFbrP
	 xXf9IFHK30cCq0jsT0ta//Dywoyhjetu3hh4MW/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dexuan Cui <decui@microsoft.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 145/307] hv_sock: Return -EIO for malformed/short packets
Date: Tue, 12 May 2026 19:39:00 +0200
Message-ID: <20260512173943.188370049@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 net/vmw_vsock/hyperv_transport.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 76e78c83fdbc..f862988c1e86 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -704,17 +704,26 @@ static s64 hvs_stream_has_data(struct vsock_sock *vsk)
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
 
-- 
2.54.0



