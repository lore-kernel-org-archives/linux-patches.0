Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4704D9EA;
	Wed, 19 Jun 2024 13:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803568; cv=none; b=QiNCHA55bp0NkkdGsNG21E9rf0tXA/yAHdvPoQIzknLkqNGEd6R5Ej4amrdDboGk0cjC8hvBw9d1LxDSiEZ1btIq7D0o7cPJmMRn6bNZc1qVpIZJs7CvbZ4/fWUvw0UdQbqHNGMLXhBm1FaI9YcRHmUzoHk7cpgSi8adz28jOi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803568; c=relaxed/simple;
	bh=+zmmyJBOoKYHe2eKKN/OuBy+zE/Kr5nGVuuRXYt83UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDNcbMKHvzXh9MLnI3kqFyK0NzvexRsVqSaT+CVo4BCNCKSZWYWOn9LbQhr8wf8tFhesl+dNnY5sMkuWR5alIL1WaAqHIJDzgiIYAxOjseEj0O7AyHLNhzXGuaM6knwtY0m2R8T4p8XabKhkhV8JXeFRsNM/U0CBwON9aiKw4Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEQ+TlhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEQ+TlhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46234C2BBFC;
	Wed, 19 Jun 2024 13:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803568;
	bh=+zmmyJBOoKYHe2eKKN/OuBy+zE/Kr5nGVuuRXYt83UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEQ+TlhVoDlY6J2eEtmjoQ2Fn5zvsdT+rNp2+4jF0CtKWLESnOOPtvKV6sKmdnvg6
	 wiUJ12rpqpcVpSUuWlvkVDu1ZO5itSvWN+RFpIz+jn3EtJRC+WGzhmx2UKYvKOA5Ha
	 M+o8HnXFARvru31irIoET6EFR+ABr3V792iEMk4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Kolacinski <karol.kolacinski@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/217] ptp: Fix error message on failed pin verification
Date: Wed, 19 Jun 2024 14:54:32 +0200
Message-ID: <20240619125557.773617750@linuxfoundation.org>
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

From: Karol Kolacinski <karol.kolacinski@intel.com>

[ Upstream commit 323a359f9b077f382f4483023d096a4d316fd135 ]

On failed verification of PTP clock pin, error message prints channel
number instead of pin index after "pin", which is incorrect.

Fix error message by adding channel number to the message and printing
pin number instead of channel number.

Fixes: 6092315dfdec ("ptp: introduce programmable pins.")
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://lore.kernel.org/r/20240604120555.16643-1-karol.kolacinski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_chardev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 9311f3d09c8fc..8eb902fe73a98 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -84,7 +84,8 @@ int ptp_set_pinfunc(struct ptp_clock *ptp, unsigned int pin,
 	}
 
 	if (info->verify(info, pin, func, chan)) {
-		pr_err("driver cannot use function %u on pin %u\n", func, chan);
+		pr_err("driver cannot use function %u and channel %u on pin %u\n",
+		       func, chan, pin);
 		return -EOPNOTSUPP;
 	}
 
-- 
2.43.0



