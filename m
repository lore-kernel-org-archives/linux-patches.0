Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30226EEDE;
	Tue, 20 May 2025 14:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749700; cv=none; b=akymUq5729jHcx033suCssyj/e7lK1yJH0biIITUFjnnxaZ+QOYtJTdK434ZgUDrsNEmgCCP98G7msQtxmJVCHxUoQezYQ7vfRDiEevGsfWgVR+BBakDoJHDXlNWFAg9+9jKHogrNmTalndX/P/HKbU+scyj5lS09SZ85J3lRTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749700; c=relaxed/simple;
	bh=SW1SidAaStpsAWn4FK0WKBwjr8qgsNJh1rm9Gjp7KPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ernHg9aNHuvZSjI0wZxJAa0Kj5hq0FjEYHrqJM/a5iD/A1b7iAhBmvdz2GoK9afpdp/NtRIwrjZJtQc42xULT62ImG3CFaYptkM5zG/TT/ZlTvYBa4M5feEYF4gHTj+PXmzpmrsQwUbGRTO3JG952S+op9g8TmkPupU7F73tPL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4hAbAqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4hAbAqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA66C4CEE9;
	Tue, 20 May 2025 14:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749699;
	bh=SW1SidAaStpsAWn4FK0WKBwjr8qgsNJh1rm9Gjp7KPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4hAbAqJ6bnFot1JBslNPcvbb0EeYh55Sy76Wp/lZOUhZQ+mGrqzdzREMP66KXOWB
	 H4rSId/IYaeNQCUJSRUZbQVATI7G2y34ccWOqH4aGJF4wmGGyfUqQrLrkI0LH78PX7
	 OM4vLgUP8SUsQ/oEw7k0hcMO9hvXXUdhrglFigNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/117] HID: uclogic: Add NULL check in uclogic_input_configured()
Date: Tue, 20 May 2025 15:49:57 +0200
Message-ID: <20250520125805.258465020@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ad74cbc9a0aa5..45de01dea4b1c 100644
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



