Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7838416F8FA;
	Wed,  3 Jul 2024 11:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005559; cv=none; b=XulGzVqGji67TFZRbdvNC+//qB6w0HmETU8SNrfWOpoyULMDU3N0ilg2CVv+mI5Uaistgx0R1Mzms8t/VFSDD7rTu9A3IyEszNcUocSeeU59DfjoOPqlpYiiQ/QJWdBJRN01+rDVRcUxmtlRZ0BI6hyhXqPCW4GJQWQkHeaB3xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005559; c=relaxed/simple;
	bh=zDx7H0XpdU1kZQQlWcmMqR4XiNqwxE7sH0iKeJNhCPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5nHE3AtVrwpamCnLGb8US0FzqznpyCePqZMmcN1r3nuci6VybEa/oItZR9gXE5mo2Evwa7dvZV34HqPbmINFfT7J6WJpb71Rffwv0B662dkdTxlPbaL4G69uqT2jDiTYLaEmjoykOXeSTlaqxgOXoi3ptSyanwDNf8BKUK0pXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqpZlkhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqpZlkhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F187CC2BD10;
	Wed,  3 Jul 2024 11:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005559;
	bh=zDx7H0XpdU1kZQQlWcmMqR4XiNqwxE7sH0iKeJNhCPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqpZlkheJL3U/uKjF9buOUhpXj1GoUc1sJ1xWytcUwLNnLobNinKknVtF/taGvBIB
	 b5qZKfOiE9oj5ozGOidnrnlfWaJEPUp5/+iwBOkQAqNwq9w+Vv4cLDxP3wZxWu7BmE
	 Lo/qO5pG3ZCTx2J5tmb+9PLiPbF4zNGEmSyzOFYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vamshi Gajjela <vamshigajjela@google.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.15 122/356] spmi: hisi-spmi-controller: Do not override device identifier
Date: Wed,  3 Jul 2024 12:37:38 +0200
Message-ID: <20240703102917.711404171@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


