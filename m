Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135EA24E01F;
	Tue, 29 Apr 2025 16:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945538; cv=none; b=azqkrz2QQv89RdQWhVW/+hW13Mjbl0DCBgKeWUJspsmdiGoAmeEx2jLVTGHKJgC0pDVlCT3rHcd8nHZGo2oYI1Ol5jIA43DgqnQCvNFSH38uMe+ax9N7SegNVOzk3b2Sp5CVrbFeaZ2j+1vLqzk3itoNsu0KRbZGqm30Co4HcIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945538; c=relaxed/simple;
	bh=5po0s5EpCphNcIvne1ojZG59f4aiTuSJUX+DeNPFsXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4BLCjzYck8Dpqe1Li11QxEPgFAflgA/JHnaYVhCWZMLLpx/daDRXcM6BumV1o5vZtEMvVoGLAiHxs/+t8leDroN0TcoY4T7yLVMLwd8ugQVVErdwFgMHhpfuJj6sPKdExbhO5+dtShXnYkIkwYZuwnfEedPN9r4NQK1kOazF1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HG9dzD2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HG9dzD2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BA6C4CEE9;
	Tue, 29 Apr 2025 16:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945537;
	bh=5po0s5EpCphNcIvne1ojZG59f4aiTuSJUX+DeNPFsXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HG9dzD2CR/R76t+MrwlF3gvsUZACcwN1MDzx5+qFHmCrsG8VZvCmZBhUqZJgI976l
	 rq/EwKg3PPPEo5irkCoSMnyJ8rBCpWfGiQuRiG2Ip9qCNqG09da3bWpqnxpJ65atqo
	 WA6L2lWhwsczWpXy9PDV3PKjDJw+SM1cJ7xQf1Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.4 146/179] virtio_console: fix missing byte order handling for cols and rows
Date: Tue, 29 Apr 2025 18:41:27 +0200
Message-ID: <20250429161055.296332593@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Halil Pasic <pasic@linux.ibm.com>

commit fbd3039a64b01b769040677c4fc68badeca8e3b2 upstream.

As per virtio spec the fields cols and rows are specified as little
endian. Although there is no legacy interface requirement that would
state that cols and rows need to be handled as native endian when legacy
interface is used, unlike for the fields of the adjacent struct
virtio_console_control, I decided to err on the side of caution based
on some non-conclusive virtio spec repo archaeology and opt for using
virtio16_to_cpu() much like for virtio_console_control.event. Strictly
by the letter of the spec virtio_le_to_cpu() would have been sufficient.
But when the legacy interface is not used, it boils down to the same.

And when using the legacy interface, the device formatting these as
little endian when the guest is big endian would surprise me more than
it using guest native byte order (which would make it compatible with
the current implementation). Nevertheless somebody trying to implement
the spec following it to the letter could end up forcing little endian
byte order when the legacy interface is in use. So IMHO this ultimately
needs a judgement call by the maintainers.

Fixes: 8345adbf96fc1 ("virtio: console: Accept console size along with resize control message")
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Cc: stable@vger.kernel.org # v2.6.35+
Message-Id: <20250322002954.3129282-1-pasic@linux.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/virtio_console.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1619,8 +1619,8 @@ static void handle_control_message(struc
 		break;
 	case VIRTIO_CONSOLE_RESIZE: {
 		struct {
-			__u16 rows;
-			__u16 cols;
+			__virtio16 rows;
+			__virtio16 cols;
 		} size;
 
 		if (!is_console_port(port))
@@ -1628,7 +1628,8 @@ static void handle_control_message(struc
 
 		memcpy(&size, buf->buf + buf->offset + sizeof(*cpkt),
 		       sizeof(size));
-		set_console_size(port, size.rows, size.cols);
+		set_console_size(port, virtio16_to_cpu(vdev, size.rows),
+				 virtio16_to_cpu(vdev, size.cols));
 
 		port->cons.hvc->irq_requested = 1;
 		resize_console(port);


