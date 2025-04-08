Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D67E2192F2;
	Tue,  8 Apr 2025 11:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112323; cv=none; b=CapW5SW4wxpArb6XmmF0AJ9OvTdL6Wn/DQ1vrIPkVfk2XKk36aA6lPz6waBXY7NhouIUCBo9PWNHn/ZQftmeXq9MNyJGASKwkW1qqfmIAc1qh1ddggXdaQa6IvT/pYUCIVLBI/0IyiLvnWUxnmr1e430TuSbPVlmsHblYXxFhms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112323; c=relaxed/simple;
	bh=2NthrcyWtzUPYl5YYdBzgy7MEvT//P6eWtVqaMmSQyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sH6GRm9Nx0QQXp17uIdyk7FChmrDwLqlHCzZ8fz42HSzb4EYt/lVzjtTmTYe92rwLvHBijn9hl9Uq0dFSwev9jEsVwiS/A6oSum03FTGZ6aAMBGnbIKmnKspkJ8kq39Qk0cVlCLn4exdKYzshsMdmb7STLYtlRqiGIixfK3DQvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkafFUJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkafFUJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D2AC4CEE5;
	Tue,  8 Apr 2025 11:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112323;
	bh=2NthrcyWtzUPYl5YYdBzgy7MEvT//P6eWtVqaMmSQyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkafFUJQKVASMBifM3zyTwQARpzKhnrqwS4WHTCkL1Dv5ueDCIdnGkPop0aOcSL0v
	 Djzv2sqkiyebvDABpscvUopiGvYjNsFViBqyVY15FjGOt3memqBAo47IBQYdFsbNaJ
	 u4MQrLby7eJTK9MefaD3VghIW0Cnb2j1EpknIaWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/279] powercap: call put_device() on an error path in powercap_register_control_type()
Date: Tue,  8 Apr 2025 12:46:49 +0200
Message-ID: <20250408104827.089086116@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ff736b006198f..fd475e463d1fa 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -626,8 +626,7 @@ struct powercap_control_type *powercap_register_control_type(
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



