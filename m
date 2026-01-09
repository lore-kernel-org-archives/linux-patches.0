Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516013590DC;
	Fri,  9 Jan 2026 12:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963122; cv=none; b=BM+0TagQVGAdu9VkMXgTbBc7quy1BNDclCOfcVyE5SPtQykLsglwJLjhcVZMOyoJ+gXq+IqjAw5HsbekpqnytwdN5cXfwToe/VM4pZR0jHnBzhxkjxFiT3eVEFu5TcicTY5EuVFiyuyP0pdPb9XNwVNHXFx4TQJ0AQUshVSVK2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963122; c=relaxed/simple;
	bh=mXQiDMkwHNe9Rul84nHDOYNFK50d94LoAioa4XmA+lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9/MS27pPtmvRju+Vk+Q4efgnlbGw/d2VQqGYfKm7D6/379rO9vILdRcw44X39EXlBwarTPYo6cb32eK/HhgEz9YHOvBIxkI8BUCFnphfJbC4Psg9c6zKy2fT3VWVOyfpjuaSCJi+VcUwuGm/uYrNstO0ZN8LUnaCRRvZievrOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8FFOdaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8FFOdaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F433C4CEF1;
	Fri,  9 Jan 2026 12:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963121;
	bh=mXQiDMkwHNe9Rul84nHDOYNFK50d94LoAioa4XmA+lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8FFOdaYfgoZFBC3msPSz9FEQCoW8LR0DsPijjcQ4VF1JOl3Udhlz167sjVVK5w0s
	 KEEBXFjKv9SB8Emrbah7EKi6IaDghcMRXzjEUbUo+uTWfKssHzK7ehkViPPOKjBraY
	 atsDNIaeY1YJFlXHKHnHuBk7WWKCmnanntnNVEis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Filip Hejsek <filip.hejsek@gmail.com>
Subject: [PATCH 6.1 605/634] virtio_console: fix order of fields cols and rows
Date: Fri,  9 Jan 2026 12:44:43 +0100
Message-ID: <20260109112140.394594927@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1615,8 +1615,8 @@ static void handle_control_message(struc
 		break;
 	case VIRTIO_CONSOLE_RESIZE: {
 		struct {
-			__virtio16 rows;
 			__virtio16 cols;
+			__virtio16 rows;
 		} size;
 
 		if (!is_console_port(port))


