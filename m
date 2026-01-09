Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ACF32AAB5;
	Fri,  9 Jan 2026 11:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959073; cv=none; b=fF4guB9SL4kalyGbHGVhZckL6xkwgMH3BTRhoN6yQ+ZfDesfR7DKb7aejNFdi9kf4Bca1NFGv+F9iBjNYfswe94bQ4N/Vy/CSp3LEe4c9XdxgJi0VmlFOLZ6ozsLhcgAqAICJPosEfhX6SQ/U8gSQmLGkk4bmnNmZglFoPd7VXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959073; c=relaxed/simple;
	bh=ClcuMyxAjsKIxo+NQtJsY/E9QjvXGXtqtMxAcDF8t9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kE3HbNzHOAYq2G/hvVLDM1SHY7xkV6V2QiFr/ycV8ofX1KZnqfrrw3Ys5YC/6Ogvwe9MRDCMxF7jQyS/hiexV50mal9yuzNt4H8BqoIrf7Bva14kQlQTNlX5dlXYM4oyP62oRoWNrj2kUp6MvoeZZcQ9hg5vdTPxvrUd8bcIrzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Ky9Nda/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Ky9Nda/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754A6C4CEF1;
	Fri,  9 Jan 2026 11:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959072;
	bh=ClcuMyxAjsKIxo+NQtJsY/E9QjvXGXtqtMxAcDF8t9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Ky9Nda/JNkL+3k2C9pE/bHnXLN4iG0bdlSnR+k66OhHLqugLtm2Ac0/h+wdbr1S3
	 IrjN8v/2TxZP8Ad8DObqEoHiQtK7nUkLzPsKZmjHjcIGIlGU1HJYME6wlo5BItq3KW
	 rrB1EU3HgRKmJ4o5r/Qk+V7ztPZ1hTOlxmkGMFno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Filip Hejsek <filip.hejsek@gmail.com>
Subject: [PATCH 6.12 14/16] virtio_console: fix order of fields cols and rows
Date: Fri,  9 Jan 2026 12:43:55 +0100
Message-ID: <20260109111951.959613197@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
References: <20260109111951.415522519@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1579,8 +1579,8 @@ static void handle_control_message(struc
 		break;
 	case VIRTIO_CONSOLE_RESIZE: {
 		struct {
-			__virtio16 rows;
 			__virtio16 cols;
+			__virtio16 rows;
 		} size;
 
 		if (!is_console_port(port))


