Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C081E47B4;
	Mon, 21 Oct 2024 10:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506822; cv=none; b=jnfvdJOndqqfDwsjUKjCJR8ImVk4XbaClpQnK6p2dFOQ2Fr3na3zPVaYiuoxI+u/WbetkKp9V46keH138kxX1dZATm8mToYGseTCm4Lm2x5JRX53VWjFeKdt4aeDCp1wv08Pz8RCwbSxqirwZiXgcPOkJBCmCpNWjaV2x0IO4E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506822; c=relaxed/simple;
	bh=zp3Pz3eeAedYBZm/La51PDR8UgZJQ8BA8cIdXs8ffH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QK33iWTPmA5kfpIEZM5yyyYjTvbqrSu1/NuP4lVvM1mON/BFDiyDnE+q3lYVIiGxx1XHb9Qbhd7giZwNbiT7jjUwuxZMFim2GXevbWGSvttDgOEUFlpqZndBtLmZXW2Og31K8KoeWZliB3G/NII73RDuFpsVYZxq+IraQ4KDexI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ym6mUthz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ym6mUthz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603E8C4CEC3;
	Mon, 21 Oct 2024 10:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506821;
	bh=zp3Pz3eeAedYBZm/La51PDR8UgZJQ8BA8cIdXs8ffH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ym6mUthzAVUdNtDHBVVdTMTKUgOBbi5r4tnfY7lowyESuuxkd1G4jMAjq2rYZFzz/
	 WsFo2DO/LH1uVcbI9R5iD3OE0UcUHr4ojAV7sWGRulS/PF87ioN9DaBza7KpM2dVYS
	 sXxaKDfY390pvqWn04wZBrHPRsWicQNo9DwC8a3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jonathan Marek <jonathan@marek.ca>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.11 105/135] usb: typec: qcom-pmic-typec: fix sink status being overwritten with RP_DEF
Date: Mon, 21 Oct 2024 12:24:21 +0200
Message-ID: <20241021102303.434647004@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Marek <jonathan@marek.ca>

commit ffe85c24d7ca5de7d57690c0ab194b3838674935 upstream.

This line is overwriting the result of the above switch-case.

This fixes the tcpm driver getting stuck in a "Sink TX No Go" loop.

Fixes: a4422ff22142 ("usb: typec: qcom: Add Qualcomm PMIC Type-C driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Acked-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241005144146.2345-1-jonathan@marek.ca
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c
+++ b/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c
@@ -432,7 +432,6 @@ static int qcom_pmic_typec_port_get_cc(s
 			val = TYPEC_CC_RP_DEF;
 			break;
 		}
-		val = TYPEC_CC_RP_DEF;
 	}
 
 	if (misc & CC_ORIENTATION)


