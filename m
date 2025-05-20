Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BA51922ED;
	Tue, 20 May 2025 13:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749375; cv=none; b=a5da+/lXNOEj7WHdSVj7nDxLHhitd2Os/gJXXQMSVgBxZbwFOGKHpuFbqYENZM9Grl85dgnoi2NLlLfsvxWpJUkPUJFTPkd7cnraNrBM91HoNCXAJVv0n+YGtwhy/WLIu0HR0i+mSPmcCoQv2pX8254ZBD6W+N4XkiUgcwdxy0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749375; c=relaxed/simple;
	bh=JdqW5AH55giq3tM8k3PnWRlD/47wfWX5S7FsLFBnRR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7HIiMxcYVH9kw9CMA6jsrj94T+FjBYHvChdXPMNwU6Hfa+I1Ov4IUqE3EocTSn1ES1+HRVx0XqvpUoa4b89MxYQHpGsQZytAi43C1Yj2OR62OqJPcYxkAjF8+a7nf9qRpI0L1k0wgfwibaNIBMDp2AApsykPNK80M4BRkBoCII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHlEQjho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHlEQjho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9186C4CEE9;
	Tue, 20 May 2025 13:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749375;
	bh=JdqW5AH55giq3tM8k3PnWRlD/47wfWX5S7FsLFBnRR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHlEQjho5+2CCClQz0/gC+EtG+r5KkPPpcOhdVRwEo+V72j6NufgZt5NjTTREY0Gn
	 zoO0Lu/SrX6ulnDwtr8F2gNoXs1gkMaupX6dOn1Msov4ocNrVPEAxCs+mRRi4Y7BbP
	 QroWmAw4DIHvKMSfPsr5rbdYW6zrvi+FRXVIiEbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/97] HID: uclogic: Add NULL check in uclogic_input_configured()
Date: Tue, 20 May 2025 15:49:49 +0200
Message-ID: <20250520125801.611793617@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-uclogic-core.c b/drivers/hid/hid-uclogic-core.c
index 39114d5c55a0e..5b35f9f321d41 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -142,11 +142,12 @@ static int uclogic_input_configured(struct hid_device *hdev,
 			suffix = "System Control";
 			break;
 		}
-	}
-
-	if (suffix)
+	} else {
 		hi->input->name = devm_kasprintf(&hdev->dev, GFP_KERNEL,
 						 "%s %s", hdev->name, suffix);
+		if (!hi->input->name)
+			return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
2.39.5



