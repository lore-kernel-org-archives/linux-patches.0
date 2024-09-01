Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463322B9C7;
	Sun,  1 Sep 2024 16:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208551; cv=none; b=pG8rKIHw2Td1ms8i7pMmyYTStqXAmJTp/5J+UgpYg7b9SY1CXza/zgRqV2T8eEBdTpE+J40TnwENa5yR6FOhgjZNbd3ML2KuliblQ8eU+6rVL6V1vm4C6uKLXvFdBrRI71j6eGdm11l2/E8ZFmUx1KnttYFtcfXKftGY8hITWiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208551; c=relaxed/simple;
	bh=BRO6dht36ItnCmA+nsFHxCWq9Eb2eSFfvQNxzahG9AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3zNPvKxTl7H/4imz1yrz5ECavVsoPas1EupP3mExQ3MjDmon2ZiuOsdRcsSoaM8/b97nggZ5VKWqszKplEZNrS6w1/cQpmh0Oh+FUI7zYgkbOGz2H5649h/l3kY7qGJADi3oVdZ+bH3/tc0wrSe0o/x2FhRY0HCqWXAVwNTSLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0pDUAoO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0pDUAoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90163C4CEC3;
	Sun,  1 Sep 2024 16:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208551;
	bh=BRO6dht36ItnCmA+nsFHxCWq9Eb2eSFfvQNxzahG9AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0pDUAoOpSo3cGRNYxfih9gDpIdePFutoPq3DlfNT7RTxqdjwbxbEmWoCSi0g5Dtj
	 iJYw7kFmDg82/s/4SIL8Nz6Rfe7pJ8U/8wjCCpoUWZynp3N4G3vgKUAmX1jbQaOaic
	 ar4gC3oD40d2jSrASkQ21I/hlFaAx+vdAakZxric=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 116/149] soc: qcom: pmic_glink: Actually communicate when remote goes down
Date: Sun,  1 Sep 2024 18:17:07 +0200
Message-ID: <20240901160821.819831429@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <quic_bjorande@quicinc.com>

commit ad51126037a43c05f5f4af5eb262734e3e88ca59 upstream.

When the pmic_glink state is UP and we either receive a protection-
domain (PD) notification indicating that the PD is going down, or that
the whole remoteproc is going down, it's expected that the pmic_glink
client instances are notified that their function has gone DOWN.

This is not what the code does, which results in the client state either
not updating, or being wrong in many cases. So let's fix the conditions.

Fixes: 58ef4ece1e41 ("soc: qcom: pmic_glink: Introduce base PMIC GLINK driver")
Cc: stable@vger.kernel.org
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Amit Pundir <amit.pundir@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Link: https://lore.kernel.org/r/20240820-pmic-glink-v6-11-races-v3-3-eec53c750a04@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/pmic_glink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -175,7 +175,7 @@ static void pmic_glink_state_notify_clie
 		if (pg->pdr_state == SERVREG_SERVICE_STATE_UP && pg->ept)
 			new_state = SERVREG_SERVICE_STATE_UP;
 	} else {
-		if (pg->pdr_state == SERVREG_SERVICE_STATE_UP && pg->ept)
+		if (pg->pdr_state == SERVREG_SERVICE_STATE_DOWN || !pg->ept)
 			new_state = SERVREG_SERVICE_STATE_DOWN;
 	}
 


