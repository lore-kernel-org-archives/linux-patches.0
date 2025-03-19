Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FAD1DE4C8;
	Wed, 19 Mar 2025 14:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394867; cv=none; b=RLLaln9cobJ2kEPWKU4MPkHSE238qtp2Px6HndcQlvGr+REFK0TU1z2r3DsfjRk8rsq0dowKdLNymVi1w49vMOooAw0oLKHsTtZleZSZBFD9gL2R7YK4dNqtGQLC0yyuHETG50mepX+w7XmIcdpKNYUIWRh7QLVS6sbEcdcEhf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394867; c=relaxed/simple;
	bh=m2PhAC8g/KMF8gZGc5PlzpaNP4WYbon1KFo4LaSA3Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvOcTZ+qLHTLPnioBNuDo/kMcJtn6V6Etm4TntsuEB96Wl4V4Xq1PRYeGw5WcjBP5+CVpZrL9rpW6EubdmRh0nmU3SwySw7K8JjyK5xM4zMG6m4Op02WX27Oby0cXerVeGA/M2fEcAJUQ950uAuGxjFpPb+YoDkCV1zSMXb7pNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zl/ac+N/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zl/ac+N/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A584C4CEEC;
	Wed, 19 Mar 2025 14:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394867;
	bh=m2PhAC8g/KMF8gZGc5PlzpaNP4WYbon1KFo4LaSA3Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zl/ac+N/nIflCAWre3czGyokWG3VKSgTEaPEt+m/I6+rvqX7Jd0Gex0ktuEKzlfPK
	 jG0ETwK3b+R5BF8gQjGMnT0v7eyTiX71Ptur+T0QD9PNeqIBrkP/187+zM0Ta0VEOE
	 h4Gkc+dOmi/x+kD+h6cIiqp3Q1YE+k/3t7Q5EK7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 059/241] powercap: call put_device() on an error path in powercap_register_control_type()
Date: Wed, 19 Mar 2025 07:28:49 -0700
Message-ID: <20250319143029.189832772@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 93c66fbc280747ea700bd6199633d661e3c819b3 ]

powercap_register_control_type() calls device_register(), but does not
release the refcount of the device when it fails.

Call put_device() before returning an error to balance the refcount.

Since the kfree(control_type) will be done by powercap_release(), remove
the lines in powercap_register_control_type() before returning the error.

This bug was found by an experimental verifier that I am developing.

Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20250110010554.1583411-1-joe@pf.is.s.u-tokyo.ac.jp
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/powercap_sys.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index 52c32dcbf7d84..4112a00973382 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -627,8 +627,7 @@ struct powercap_control_type *powercap_register_control_type(
 	dev_set_name(&control_type->dev, "%s", name);
 	result = device_register(&control_type->dev);
 	if (result) {
-		if (control_type->allocated)
-			kfree(control_type);
+		put_device(&control_type->dev);
 		return ERR_PTR(result);
 	}
 	idr_init(&control_type->idr);
-- 
2.39.5



