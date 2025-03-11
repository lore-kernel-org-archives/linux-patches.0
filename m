Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFB425C6ED;
	Tue, 11 Mar 2025 15:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706846; cv=none; b=UUpB4LRvk2fF+42IXrrJUA3f3OU0x8P2OPXvcdMKhm+esmGIjkUAw6a0i5skylNE6kGsdulKQZK5c1cVxOAVWaq85MZkiC7zPBOK8AL59U4c56T3zrlxH+Nc4Nd8FM+IGj3RqBPWdxswf5qVvYWbTIgoQLYAkgANLz8QglKP1DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706846; c=relaxed/simple;
	bh=bNwH6N9H8Dnf8lPFwKoL3SRpTQQG5m0V6FAqP8BC25c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+C9gPj09+baBt1Tt0YK8fIZy1SDjv6BbMaF6r8/M4HQAEyQpOV2KB7nkvKeqv0LivDIM3jY8jNAjbZftwiJ3s/hlOUsak7xuWX+WsThWPkY0qGSsLF7dj9vsDuqLOlCLhWkhfEezZWRT4YgLBFGyy7bOtktpRAppAdbKaUFID8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgqrGOO0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgqrGOO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C34C4CEE9;
	Tue, 11 Mar 2025 15:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706846;
	bh=bNwH6N9H8Dnf8lPFwKoL3SRpTQQG5m0V6FAqP8BC25c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgqrGOO0Oq0LOA4A6YcCpc34ztLM1sQBmuK81otd/uj90yCrikgzzqe3yYZoOyysI
	 QDBQsDhAKcJybXt439jUYTU5bUFPRlQ9+PLwjUtiw03iKEkovoPOHDhLoOjRffPXww
	 47kukSTw2fwsKMa1HnDQER9PUHkTb+WzRWSibKzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 188/462] usb: gadget: f_tcm: Decrement command ref count on cleanup
Date: Tue, 11 Mar 2025 15:57:34 +0100
Message-ID: <20250311145805.783917147@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 3b2a52e88ab0c9469eaadd4d4c8f57d072477820 upstream.

We submitted the command with TARGET_SCF_ACK_KREF, which requires
acknowledgment of command completion. If the command fails, make sure to
decrement the ref count.

Fixes: cff834c16d23 ("usb-gadget/tcm: Convert to TARGET_SCF_ACK_KREF I/O krefs")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/3c667b4d9c8b0b580346a69ff53616b6a74cfea2.1733876548.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_tcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -973,6 +973,7 @@ static void usbg_data_write_cmpl(struct
 	return;
 
 cleanup:
+	target_put_sess_cmd(se_cmd);
 	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 


