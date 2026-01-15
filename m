Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE7739E199;
	Thu, 15 Jan 2026 17:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498511; cv=none; b=c+jW3grC8hwrXygrP64u6EV4+bcPckRajovgddhWVA6VvfDwWDsMO/LzVbR8/odhCnKtAQYDSOfzKJMFbPuLghymB+nUoU6YkM+IulzfioE4UljgX27rAAtNqbbAo+11rAJ/MxYjUiCDfR6SPM6CdyqyfoKuKpfRG3pwZ5jFQnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498511; c=relaxed/simple;
	bh=TLXzW8YcbIcST3wiUGXVf3dWqlJeKARoersSzN8nhz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZGxFgf7rcDfTpigRH+MUePfSuk0N9C/qdUbaLDT5TdlRAQTKgxT0wgC03x5cjyVJCKYAlBWSesSESi1fiexSa6/0nD6NufBzYog+HoQgsWhnv7kvC+5hf2pGHbtkRNoo6Kw6zcanrRlNVswmQN5kYG/Z6yl9oXDikWNimhQDmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppMP5gCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppMP5gCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448EDC116D0;
	Thu, 15 Jan 2026 17:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498510;
	bh=TLXzW8YcbIcST3wiUGXVf3dWqlJeKARoersSzN8nhz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppMP5gCBd2lovasrX4ze2aAWReWZ/Gn3PNkW11szQKvUWzg7/9dB+CGXIFyCkoWnV
	 HErMzPuTU+L6w4d6vB4dVWYwsLApn1tymlfDpm10KXDpom7sVcYicmaj7RtzXpaq7i
	 SSa5hFWR3sOWdNouxPyt3i1QRoFNBWbIKmBbN3SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Filip Hejsek <filip.hejsek@gmail.com>
Subject: [PATCH 5.15 424/554] virtio_console: fix order of fields cols and rows
Date: Thu, 15 Jan 2026 17:48:10 +0100
Message-ID: <20260115164301.606995044@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>

commit 5326ab737a47278dbd16ed3ee7380b26c7056ddd upstream.

According to section 5.3.6.2 (Multiport Device Operation) of the virtio
spec(version 1.2) a control buffer with the event VIRTIO_CONSOLE_RESIZE
is followed by a virtio_console_resize struct containing cols then rows.
The kernel implements this the wrong way around (rows then cols) resulting
in the two values being swapped.

Signed-off-by: Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
Message-Id: <20250324144300.905535-1-maxbr@linux.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Filip Hejsek <filip.hejsek@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/virtio_console.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1614,8 +1614,8 @@ static void handle_control_message(struc
 		break;
 	case VIRTIO_CONSOLE_RESIZE: {
 		struct {
-			__virtio16 rows;
 			__virtio16 cols;
+			__virtio16 rows;
 		} size;
 
 		if (!is_console_port(port))


