Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8975331A45;
	Mon, 29 Dec 2025 16:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025990; cv=none; b=LIXjFvryE0rxOa+E/ejWIVYqEUpBmQuAmJ5vOXt81kSsOa8hszNtjeqXYSre9DdlV60S4tcMhIVamHWZlIHwe2zly8FJl8286jJ7JjAvylmueh9Q19rCl3b/4MeIZK5Gmn/TC9w6iieecy46Di+pSy6wnJTlDyWG35L2/eom4uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025990; c=relaxed/simple;
	bh=nc/+xTsMfl6SLcfHq2wees/3m5FiWCt+YwEwUvPSHSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXS/P9tH1jSKSCK4nvblAchVj2+NOg84gY12XpQdY3lidcEJ5iJciBANHGm63QMW7Xzbf5q+Aj6vp3d6ypm0qh0/ovnImA58pb2ehnvcmMOtnCCYcqzpaFndhjoZzBQ4OsMDhqe5IkQQleYCkmFkhWAmPk3VXfGCawA11n0+G28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3UK+0Ox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3UK+0Ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FFBC4CEF7;
	Mon, 29 Dec 2025 16:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025990;
	bh=nc/+xTsMfl6SLcfHq2wees/3m5FiWCt+YwEwUvPSHSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3UK+0OxLgpb3cOZdEBCu3OmjFw2vp0A263dy0aPio+4RiUBJU7qXosyNXzUSyrzd
	 GzHfK6/tMJ0B2Gqxv+n+fURSgxCh74XoDYBxzc4povcHmXa1upRNUwz/LfZd+kGvyf
	 C1cmd1e0NA+6lrOs5t5QIk9xEvriLW+gTzSaVxR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjelique Melendez <quic_amelende@quicinc.com>,
	Johan Hovold <johan@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 407/430] soc: qcom: pbs: fix device leak on lookup
Date: Mon, 29 Dec 2025 17:13:29 +0100
Message-ID: <20251229160739.290419376@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 94124bf253d24b13e89c45618a168d5a1d8a61e7 upstream.

Make sure to drop the reference taken to the pbs platform device when
looking up its driver data.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Fixes: 5b2dd77be1d8 ("soc: qcom: add QCOM PBS driver")
Cc: stable@vger.kernel.org	# 6.9
Cc: Anjelique Melendez <quic_amelende@quicinc.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20250926143511.6715-3-johan@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/qcom-pbs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/soc/qcom/qcom-pbs.c
+++ b/drivers/soc/qcom/qcom-pbs.c
@@ -173,6 +173,8 @@ struct pbs_dev *get_pbs_client_device(st
 		return ERR_PTR(-EINVAL);
 	}
 
+	platform_device_put(pdev);
+
 	return pbs;
 }
 EXPORT_SYMBOL_GPL(get_pbs_client_device);


