Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34061D555;
	Thu, 23 May 2024 13:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470123; cv=none; b=AFUtfm1Ue/k7s53b071sF7dLBki0g9jGL6drfF+SobN+LJR0exU9juStw5wn5EYob7gAbmLCPXk3safjrrJQUTHfumSgBj7CNQnNq+Tr05PeUU1Tte8e0dXRDYpB0gjO16dpofyGN6UE6/XpLRIaQp48QxVfgycfXvatGSWVKrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470123; c=relaxed/simple;
	bh=Rk7pnm6VY1UMWYJRyfvM/+wWQrhcXbvS4opzk2UqXoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IK8UXSrryIfx6rteCW06XltbzkUKI+UX3SZF+YCBb9647dlyYtlAOs50T3sy0Ov5neAPo+v0QB/AVGwLgM36ICGjhodeOMPF6eYx241wSc6T3cdd4ZQ5B9xWTEvdTngueypfhX+LJPPWWT50PWIa3wxI37Llnp9lb0REDkzFHhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1OELRbfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1OELRbfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64522C2BD10;
	Thu, 23 May 2024 13:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470122;
	bh=Rk7pnm6VY1UMWYJRyfvM/+wWQrhcXbvS4opzk2UqXoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1OELRbfX36APNjRu5FmthZCZBuXPk2oEyacri5+dC5WHh98BG8LWH/MKeP/SW9OGG
	 SNAe4eqlYzGzVasdRRnNOupZHALO3j/NvFmKrdf9CNkiRD9GFpRGPCk5kYjtUVmHh9
	 TkCDOTA4/RTE3ZTpeKC0/LL2DGSnRFPGSuhPgdYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.4 10/16] firmware: arm_scmi: Harden accesses to the reset domains
Date: Thu, 23 May 2024 15:12:43 +0200
Message-ID: <20240523130326.138140225@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
References: <20240523130325.743454852@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -135,8 +135,12 @@ static int scmi_domain_reset(const struc
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
 


