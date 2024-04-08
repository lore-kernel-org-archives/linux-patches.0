Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843577F49B;
	Mon,  8 Apr 2024 14:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584958; cv=none; b=S7TSXVNvUZ9Hby+SoOdiMLIbjhi4PAF3TbLf08aRn8ZIncLIsz9YVSPG9vNlq5qR2FANKdNUAe2DqYGxJCW7lv0/04gjFFSJ45f81DQy0ohkQ1vi7SkbG3CPe6qxKnW1HOiNnFnmImrNp3N4w9lMVq8rcaMHvXO39AMCdrzaqGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584958; c=relaxed/simple;
	bh=5LR9WsTkNRNnlD1au0b7xS4u7ImkjJGvS1kOAh0235I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9b58BAJpXoNF1Lp5o9xsSbpRv7PeHFfOdN8t9xIcqKkfuyTu/C5ZrBuQe5oZFhva3NHafiaf1lC3UFAaLQYM+FDVgQfYznbEmwPHYe8GNQ+pCfnwqA6775evm8kIfzbA2JbNp8BjjLZK0wAV+UB2Mi5hq3zQZiU67V490UjJDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CyC/4wzj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyC/4wzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA26C433F1;
	Mon,  8 Apr 2024 14:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584958;
	bh=5LR9WsTkNRNnlD1au0b7xS4u7ImkjJGvS1kOAh0235I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyC/4wzjLKjw7vp0gM4Gpoc6RhZ4nwd11D+5ySCQYhpvprrMfhuz0OPkY3F/B+ZPk
	 0PRUvvWE4qvgwkpJQ7Fz5ASyR/z3u+bLljle92d94rbfa1S7be8K2kROSzutWEaU+i
	 JNfFrD1TzMSKrfQC7MClRxtZ7IqAgq2pUkzgtiDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 5.15 584/690] staging: vc04_services: fix information leak in create_component()
Date: Mon,  8 Apr 2024 14:57:30 +0200
Message-ID: <20240408125420.733504272@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit f37e76abd614b68987abc8e5c22d986013349771 upstream.

The m.u.component_create.pid field is for debugging and in the mainline
kernel it's not used anything.  However, it still needs to be set to
something to prevent disclosing uninitialized stack data.  Set it to
zero.

Fixes: 7b3ad5abf027 ("staging: Import the BCM2835 MMAL-based V4L2 camera driver.")
Cc: stable <stable@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/2d972847-9ebd-481b-b6f9-af390f5aabd3@moroto.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c
@@ -942,6 +942,7 @@ static int create_component(struct vchiq
 	m.u.component_create.client_component = component->client_component;
 	strscpy_pad(m.u.component_create.name, name,
 		    sizeof(m.u.component_create.name));
+	m.u.component_create.pid = 0;
 
 	ret = send_synchronous_mmal_msg(instance, &m,
 					sizeof(m.u.component_create),


