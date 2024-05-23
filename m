Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ED114AD1A;
	Thu, 23 May 2024 13:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470208; cv=none; b=EjyQeZykbia7IEScrF6fC+HhkuCn5QLJeHp403doFk17EZPckHDbnoZNgrI1w13/e6A0J3JwTpojt0ztBHpHOdvWBpcV6j20O0n3D1nFUHHKsXgpKIVtJbMcR8qxQEzBI7Ds3V3YQ4+w9jETcyKgQUjwjaUdKQMsIt3rzJ5LSQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470208; c=relaxed/simple;
	bh=GA3yAKUjZ1wAUpWILx8kp3nY6/HyLdlwVvA2nHeFazo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qf0d0g1yGqWrlfTIVr4BGATnUjjJtKHMHoQXHFgMZ1V+A65hYYLvrdgNDsfQl7tNdokyoUvAXFaAXtt7cDFHg1FrsBZYynTzH11upaNnYbvyl+JUGb1HfqH1nTYYkE/wV84T2KY20MKRKzUbICFpW/Shf9BzGycYfn4qdV3xOSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s68ScNy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s68ScNy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08408C3277B;
	Thu, 23 May 2024 13:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470208;
	bh=GA3yAKUjZ1wAUpWILx8kp3nY6/HyLdlwVvA2nHeFazo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s68ScNy1nb5XgRKqN6YNrZ8SboUeylIMoJWHX8Jk5/c/YWrbUX7qk6IogwzDisN5h
	 gcqjXskrDwnxAIsOLiq3d+wMGYKUkKi3TrAkJcVHYIZa7LIyJ6aTs3nRPX2H7FQeJb
	 icpKSTE/lAzrG12vyZcVVYm4s3Fw6numelUF5jQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.10 09/15] firmware: arm_scmi: Harden accesses to the reset domains
Date: Thu, 23 May 2024 15:12:51 +0200
Message-ID: <20240523130326.807080092@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130326.451548488@linuxfoundation.org>
References: <20240523130326.451548488@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

commit e9076ffbcaed5da6c182b144ef9f6e24554af268 upstream.

Accessing reset domains descriptors by the index upon the SCMI drivers
requests through the SCMI reset operations interface can potentially
lead to out-of-bound violations if the SCMI driver misbehave.

Add an internal consistency check before any such domains descriptors
accesses.

Link: https://lore.kernel.org/r/20220817172731.1185305-5-cristian.marussi@arm.com
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/reset.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/firmware/arm_scmi/reset.c
+++ b/drivers/firmware/arm_scmi/reset.c
@@ -149,8 +149,12 @@ static int scmi_domain_reset(const struc
 	struct scmi_xfer *t;
 	struct scmi_msg_reset_domain_reset *dom;
 	struct scmi_reset_info *pi = handle->reset_priv;
-	struct reset_dom_info *rdom = pi->dom_info + domain;
+	struct reset_dom_info *rdom;
 
+	if (domain >= pi->num_domains)
+		return -EINVAL;
+
+	rdom = pi->dom_info + domain;
 	if (rdom->async_reset)
 		flags |= ASYNCHRONOUS_RESET;
 


