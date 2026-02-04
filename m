Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62C1285404;
	Wed,  4 Feb 2026 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217322; cv=none; b=IghxJAKaUowuxSKFAs73Q9gtOdEyeXkL6qAG0tya6b3mHGDYo/Mmg/9+q7FUPl4/pdhJ34CKO9VVfqmQlE7NsB4FhOefN0NCSaGf8wfaX6ny0dj3id4oJhxHH/umtzgXse+AzU1FPCg4bwPOIJAJJ0HErIVCM8EHhe/Jm5shJXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217322; c=relaxed/simple;
	bh=wvloUMkLmOdLVJH7JpDOuEVeaqAoU/fXfLsti+5kZFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8H1oI+6BnAwsWPMZ+4ojZlitfwitv3O+6en7/JU7TrlGN5FgArQRhz1MdVYsvtUtFYgsI629XCvDY6bSnFdAIrFzU3UuiaOYn0CUl4r5AG1FvpTXAGgujDp0Od+m8Uk8UyRe9cPy6I+RL6jv96CAkPp3/x0WQy9vGHgq+5EZZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtySJfXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtySJfXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F02C4CEF7;
	Wed,  4 Feb 2026 15:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217322;
	bh=wvloUMkLmOdLVJH7JpDOuEVeaqAoU/fXfLsti+5kZFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtySJfXPwHqR21Xx0wXt9BR0ixVfsKY7nnQwmTJd12IMTyeSOS5yHZNr/laFkItpz
	 1CBoGd+AEn8KH6ikapIoas9CebBBIiBOCm0ICG6MW5qPmuYCTPAj83ZvKa9nkbxZeH
	 /gDpKwyCb3OJAm4VuPZk45IPpkcmCUVq9S8r1hHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 5.15 189/206] HID: uclogic: Add NULL check in uclogic_input_configured()
Date: Wed,  4 Feb 2026 15:40:20 +0100
Message-ID: <20260204143905.031432190@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit bd07f751208ba190f9b0db5e5b7f35d5bb4a8a1e ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
uclogic_input_configured() does not check for this case, which results
in a NULL pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: dd613a4e45f8 ("HID: uclogic: Correct devm device reference for hidinput input_dev name")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[ Adjust context ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-uclogic-core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -143,9 +143,12 @@ static int uclogic_input_configured(stru
 		break;
 	}
 
-	if (suffix)
+	if (suffix) {
 		hi->input->name = devm_kasprintf(&hdev->dev, GFP_KERNEL,
 						 "%s %s", hdev->name, suffix);
+		if (!hi->input->name)
+			return -ENOMEM;
+	}
 
 	return 0;
 }


