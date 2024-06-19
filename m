Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69F31422B8;
	Wed, 19 Jun 2024 13:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804003; cv=none; b=mfIq/YjJr6VhT6Qexqf70kXetIsfbSJwTvrAlkug4puHYSTzTWZdZOjtlT9ocnkt+BkU2UTohtjEFNUdAeOxsyizc/EbvbxfRtI0MAYnN87h51YDqvY4rO+sG2NmmyC+Rxe1Kwh6OyAfBIjREXxz0LYtnQ4HbCcdtAb3HE7bOwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804003; c=relaxed/simple;
	bh=FmOFZj56RzS7QupU3W9ICnLAs5Q2kSt7j9gj5YnKOHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSlYcZvwQIZeifTBWUmaH7K7rk9m7df//flZImy0ONtuc2AE4Y2EmIOoaEX64nkWeAV94Xs8Y6VOpioM/3RQTkTh28fjv2oQ8wRNWn7B0E+0mKcxbCeAH7uGvXfdtWQRKYKkhk/Jy0quMFa6c+c0Pn43GwoiriWdhe+ib41ogMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vST91DW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vST91DW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C775C2BBFC;
	Wed, 19 Jun 2024 13:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804003;
	bh=FmOFZj56RzS7QupU3W9ICnLAs5Q2kSt7j9gj5YnKOHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vST91DW3XGF4IQTr049yFWyybevAFHUVpzgwxiRqQWgA3wkPC3YWtrUbQl30D86IC
	 iFqB7XQISdq1gbTldAs80PEDVu685i9maCeVaWIV5vhMEUCO6rGgDTyI39V0Ag9fSB
	 vSv28NZEdRMYSUajvG25EvOv9ckRjjQ+0KwLtfGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vamshi Gajjela <vamshigajjela@google.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.1 177/217] spmi: hisi-spmi-controller: Do not override device identifier
Date: Wed, 19 Jun 2024 14:57:00 +0200
Message-ID: <20240619125603.516595250@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vamshi Gajjela <vamshigajjela@google.com>

commit eda4923d78d634482227c0b189d9b7ca18824146 upstream.

'nr' member of struct spmi_controller, which serves as an identifier
for the controller/bus. This value is a dynamic ID assigned in
spmi_controller_alloc, and overriding it from the driver results in an
ida_free error "ida_free called for id=xx which is not allocated".

Signed-off-by: Vamshi Gajjela <vamshigajjela@google.com>
Fixes: 70f59c90c819 ("staging: spmi: add Hikey 970 SPMI controller driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240228185116.1269-1-vamshigajjela@google.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20240507210809.3479953-5-sboyd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spmi/hisi-spmi-controller.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/spmi/hisi-spmi-controller.c
+++ b/drivers/spmi/hisi-spmi-controller.c
@@ -303,7 +303,6 @@ static int spmi_controller_probe(struct
 
 	spin_lock_init(&spmi_controller->lock);
 
-	ctrl->nr = spmi_controller->channel;
 	ctrl->dev.parent = pdev->dev.parent;
 	ctrl->dev.of_node = of_node_get(pdev->dev.of_node);
 


