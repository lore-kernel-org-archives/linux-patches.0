Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C594E15ADB4;
	Fri,  9 Jan 2026 12:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961374; cv=none; b=GMJr4m3v7nSZ5elb95vMdvlHeL/wJw495SFnH2SQ0AXeN/CFstvyV/e9P/WgSBxxJZG9J+jGGEjHnHHe8ZZ90RVzEgpw0B/iji2Ws3EE4A3Lbfeiqm8YW4eUSghIhS5SStEGxM2r5AQk9gL7+JgkGxo0D+IUep7ErVSXs/CaZ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961374; c=relaxed/simple;
	bh=wCIv9+LTbEXIt8VgL3twRiupPP7j+S20XWUo8tf/IaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJPs10a8Df398/7lBv1TJl3CXNBHbq6GvKDSt/pDNyPmKi8LYqBdwIzhUzdQk2fFM+7NV+FbMzvCfPdz110WRgN/+VdsqiIA2ZS4KwSNHoxQ9/XoyUjywTaxZJ3T2IG7qr3Ttg9WTPgABIuIb/kGbEJIPVQl83WbqIxLePe1zV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ab2gWkYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ab2gWkYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FBBC4CEF1;
	Fri,  9 Jan 2026 12:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961374;
	bh=wCIv9+LTbEXIt8VgL3twRiupPP7j+S20XWUo8tf/IaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ab2gWkYGLLIt78AOCRC9tFPeczAQBjgY01zd6L1lkk+rgH8kDc/xtgfYOyxWnbMUS
	 +/dQTemVoro6NLLcnzKzkBtou8iMGrInhXG2EneaJqabxX9BMsErQgwSjxPPD9R6zK
	 0eR9lWrNLCeRi65l2xPQ7htcA1Qg/TOP0YLILa84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Filip Hejsek <filip.hejsek@gmail.com>
Subject: [PATCH 6.6 730/737] virtio_console: fix order of fields cols and rows
Date: Fri,  9 Jan 2026 12:44:29 +0100
Message-ID: <20260109112201.566747040@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -1612,8 +1612,8 @@ static void handle_control_message(struc
 		break;
 	case VIRTIO_CONSOLE_RESIZE: {
 		struct {
-			__virtio16 rows;
 			__virtio16 cols;
+			__virtio16 rows;
 		} size;
 
 		if (!is_console_port(port))


