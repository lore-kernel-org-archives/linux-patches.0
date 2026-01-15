Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E7A3624C4;
	Thu, 15 Jan 2026 17:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499777; cv=none; b=X+Gbbglja1SQSPXQ/eM3sTWCt0zn/ziBTx6oQsgfrSZq69EV0YDvqZXsDmPKPCcNPJefUaMNZwtoG0l27We5NTPfdZXBsBmgPL/RU5eryvzRnRTqavxNLubLvYFdV9gvPpJbF3MCmv4nR8SkrBXRQ9R9DZpRGRYucSBszSESemA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499777; c=relaxed/simple;
	bh=RhSlbeUIum+7yH8JIRPB2hymLq8eToLWOvBt0BppZVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kjl39rYdbopZ9296SO7KSlEBXzNTv0wkdaElvUcaCkEUCvLSliYa3WRjcnLST5GCPfoT4mExCagoJw1nf5uB+dyKKZyB2W6pXiKiKxOO2zBVldwoQqaQkxqMjcD5MdiSDfhz1o6ZTP08ows2gMpqJiBcYaZhjmdCZ4wHraLwahw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAxdG73g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAxdG73g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4659FC116D0;
	Thu, 15 Jan 2026 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499777;
	bh=RhSlbeUIum+7yH8JIRPB2hymLq8eToLWOvBt0BppZVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAxdG73gz9QqtyZf6s5o8TagqWU/FFnC7hJluwqLAceDpEgTNEW8+wqNagpHQ0p4U
	 fcAjBJKeaiNz7fvEVxHsvV7REmfEqGJmpLB/Pw1kl4bogLDCVeE18eCMWc5vTXC0gz
	 ZQ+aiFTB0jMJwkDYhsfpH+TdF10cEOeKH0r5dxqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Filip Hejsek <filip.hejsek@gmail.com>
Subject: [PATCH 5.10 339/451] virtio_console: fix order of fields cols and rows
Date: Thu, 15 Jan 2026 17:49:00 +0100
Message-ID: <20260115164243.158335026@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1617,8 +1617,8 @@ static void handle_control_message(struc
 		break;
 	case VIRTIO_CONSOLE_RESIZE: {
 		struct {
-			__virtio16 rows;
 			__virtio16 cols;
+			__virtio16 rows;
 		} size;
 
 		if (!is_console_port(port))


