Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116BF3563D2;
	Tue,  6 Jan 2026 17:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720598; cv=none; b=lbtipTS45R2ZZBLhzDeldV29AErED6lYm42CrY/RG66cEyP5UelVz6qnu3AENKADAwI0Q3waYUKnvr57dJurDSVOl94ZURSDrR/AAbcHybbYF+a/8IF8tw0O/ww63ejMT3gR7wb/hd9z2cRNVSQz92d8e4kvXaFdCI4ubdfkTE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720598; c=relaxed/simple;
	bh=0mfibLpCfBj57MKw+m4h7KVnrHuLu9MAzinrJfG8fvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xz3wrwb8Sb7Pc+G9FiifnbmfTgXL61SNW8fI2YZD2pFcNx3sbJwM/C4BfYjrff8vUeobgzM7UBc8zYx19jxwg60b643je5JXZ6OvKJXXtJNwLxzzmq0E7b7NQyk84jxK/uWLKeR0EDWwWfbdXLH9twLr6d3uusfNSzR2+Q0JDTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrwnaShN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrwnaShN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879D4C19423;
	Tue,  6 Jan 2026 17:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720597;
	bh=0mfibLpCfBj57MKw+m4h7KVnrHuLu9MAzinrJfG8fvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrwnaShNPQS/tExg4PjzCerr4/dnYNYhzJiiTU5sfUeeyG885KJPYIkGXrENH6Pfu
	 vFLW7T1errTBeOZBW0VXMiWYYf1Uz+tRrhQ50kZUVEnzMtYj5PKJFtegVWGMwvm2TP
	 LixhwsdmlBGIpP5c7OpDJIKyqtLKIeXE8akiWv+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjelique Melendez <quic_amelende@quicinc.com>,
	Johan Hovold <johan@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 278/567] soc: qcom: pbs: fix device leak on lookup
Date: Tue,  6 Jan 2026 18:01:00 +0100
Message-ID: <20260106170501.612013581@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -179,6 +179,8 @@ struct pbs_dev *get_pbs_client_device(st
 		return ERR_PTR(-EINVAL);
 	}
 
+	platform_device_put(pdev);
+
 	return pbs;
 }
 EXPORT_SYMBOL_GPL(get_pbs_client_device);


