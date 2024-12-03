Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451AA1F473A;
	Tue,  3 Dec 2024 15:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239646; cv=none; b=r9xmQsXWOrcoCviwnwMgFQksF9Bo7tsdMIb3bfCtpxu5GrKYCOJ+2Cw4oyX/dcb88Zhi/PygUYEPJsVuUsMNJClq4lOqgRF+1OHW2EWAuddwzqV/Q/L8ByH1I3sC53j+76TAJO2bCK4kdYl6k3E05oleNgC0ZV9jAvQwf/ilDPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239646; c=relaxed/simple;
	bh=zflU1Ly/8wgRyPPZVOrRXN+C0fGav3GNhq9se84Fn0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tup30a0QoKXYgbi9kz3N4SEbt2xYipW39R3YV1HAIHo3k0JmVjok2FlbcgsPZLileAS/Q0kixNtNXPKvjDaJgzRbiRACoX4nRL5g2O7vqKOaA/YUDC82xhPsg58GzImfS/XkFtQn+mgX5q88gNyeWzmgGhHuhHBNxNOJWIQGkwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5QvvdPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5QvvdPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2313C4CECF;
	Tue,  3 Dec 2024 15:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239646;
	bh=zflU1Ly/8wgRyPPZVOrRXN+C0fGav3GNhq9se84Fn0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K5QvvdPXTsitGfnKd9iJQ+Pjg/h3v0g4W61c/Mn3I4p0nHovelwJNd8FGrDcQ/MIH
	 BYM97mtU9fbIGcio+hVrQ++NuYd6lQsaBfPKQEG1nzuWJQjvHsI6Juoq42ayb0eg5f
	 XWybH97qMphV9tVYYmnf8J8Q7N/ao8qfXQbTJ/sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.11 686/817] wifi: brcmfmac: release root node in all execution paths
Date: Tue,  3 Dec 2024 15:44:18 +0100
Message-ID: <20241203144022.748898209@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 2e19a3b590ebf2e351fc9d0e7c323430e65b6b6d upstream.

The fixed patch introduced an additional condition to enter the scope
where the 'root' device_node is released (!settings->board_type,
currently 'err'), which avoid decrementing the refcount with a call to
of_node_put() if that second condition is not satisfied.

Move the call to of_node_put() to the point where 'root' is no longer
required to avoid leaking the resource if err is not zero.

Cc: stable@vger.kernel.org
Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241030-brcmfmac-of-cleanup-v1-1-0b90eefb4279@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -110,9 +110,8 @@ void brcmf_of_probe(struct device *dev,
 		}
 		strreplace(board_type, '/', '-');
 		settings->board_type = board_type;
-
-		of_node_put(root);
 	}
+	of_node_put(root);
 
 	if (!np || !of_device_is_compatible(np, "brcm,bcm4329-fmac"))
 		return;


