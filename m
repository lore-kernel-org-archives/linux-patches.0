Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A815229D05;
	Mon,  2 Jun 2025 14:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873698; cv=none; b=FylsPrPKWOQdLDBQcWQBt/lkUC26OBa/hBAKRuT5Craij8wHN9NqV/Dr9G2hFoc3lTr3fsIkVBu5klzq/1JyQyR0+ixyOdIdRtdbM+7rSo0B43uD3zz4HpLtPrVSl1iwITGGvxJugvxYvnrHVt0GZ3axFQORLi0w/aOVvR3r1fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873698; c=relaxed/simple;
	bh=gFRkaLDbw1vWERFzOwJIGp6pIx+GDPKBCKlezHFQzWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKqQh/FOllJv2J9RE1AhSqNA6g4ZkiXpULBYjGRlm7dWFl2RtQUe8/2v7lrZOJKA1UAR6vbcZY80ivZcQALvzyiBDPf9c5A5DzRrhR09XnFHwot1vaduYPs9LSXraHAOQaQgTuxS1tEBfJIABA+ebKvF5wGD47ELzHGkKX+tMSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ogje7oEs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ogje7oEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226F9C4CEEB;
	Mon,  2 Jun 2025 14:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873698;
	bh=gFRkaLDbw1vWERFzOwJIGp6pIx+GDPKBCKlezHFQzWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ogje7oEsLwwlIPm7GVZ/nf3BowEtUDj3Lzz3nZpUG2B2AUhStZJKk8nG2f8DGmgRZ
	 zL2l6jJDJw+eqi4bjQ1Qq8kapniIqyajy5q9QqZ/Gb8MeJqMwkq0ttszF4URPmJH0R
	 gmQzYbKB0NClOVgarvgC2oaRuM9Pb7s1F+3Py2SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 223/444] firmware: arm_ffa: Reject higher major version as incompatible
Date: Mon,  2 Jun 2025 15:44:47 +0200
Message-ID: <20250602134349.958114306@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit efff6a7f16b34fd902f342b58bd8bafc2d6f2fd1 ]

When the firmware compatibility was handled previously in the commit
8e3f9da608f1 ("firmware: arm_ffa: Handle compatibility with different firmware versions"),
we only addressed firmware versions that have higher minor versions
compared to the driver version which is should be considered compatible
unless the firmware returns NOT_SUPPORTED.

However, if the firmware reports higher major version than the driver
supported, we need to reject it. If the firmware can work in a compatible
mode with the driver requested version, it must return the same major
version as requested.

Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <20250217-ffa_updates-v3-12-bd1d9de615e7@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 7c2db3f017651..488f8345dd1b6 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -121,6 +121,14 @@ static int ffa_version_check(u32 *version)
 		return -EOPNOTSUPP;
 	}
 
+	if (FFA_MAJOR_VERSION(ver.a0) > FFA_MAJOR_VERSION(FFA_DRIVER_VERSION)) {
+		pr_err("Incompatible v%d.%d! Latest supported v%d.%d\n",
+		       FFA_MAJOR_VERSION(ver.a0), FFA_MINOR_VERSION(ver.a0),
+		       FFA_MAJOR_VERSION(FFA_DRIVER_VERSION),
+		       FFA_MINOR_VERSION(FFA_DRIVER_VERSION));
+		return -EINVAL;
+	}
+
 	if (ver.a0 < FFA_MIN_VERSION) {
 		pr_err("Incompatible v%d.%d! Earliest supported v%d.%d\n",
 		       FFA_MAJOR_VERSION(ver.a0), FFA_MINOR_VERSION(ver.a0),
-- 
2.39.5



