Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13032F3C23;
	Mon, 22 Sep 2025 19:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570101; cv=none; b=EH5A43nAhqysDx5ZDQ+RZrZpcX3q1PG+vaXDb6ST9QEY5hbiAHcZjpPgfTav4x9mbvo5BTpQs7Gect47LwjqAFZysWc/HRR03uPic1ysNWHH4GJvr7q4qgyOh8ovR1QEPIZhfyTIuq3aQpj+e/osXVSFtq3OBIaKKslSfx/8Rp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570101; c=relaxed/simple;
	bh=n9OaBgaCQeoChOX+5YGEHO+iYgf7sfX2FQ8gSIYsMms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3ZBdYyxkhG8Tj4nqksdHMPt4VD8TyhuMDxMg78aLjiItBI647UKjQ2f+LgVAJ9odrRG9E0UBuUv6enncuvecFMSo5kbqwmeJVU2AmalCNB5xpqGZMVH39P4DeiKqY0o6R06tEFQmSLFwGm3XvtFcojvF2qBNNaRFdPBRvpVpxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiR18pvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiR18pvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3917EC4CEF0;
	Mon, 22 Sep 2025 19:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570101;
	bh=n9OaBgaCQeoChOX+5YGEHO+iYgf7sfX2FQ8gSIYsMms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiR18pvN6pv/V3RHlyhrqokPKCrpYVXIXsBc4Bo1lICjA3lk2QvMCTd7kIIzU7NbO
	 xygrVcXExOHp6VcFl61sVPnp/uZyxd6IJauOjk4KXIY+JpwmN5Q/vWEOpYiXqzJZtY
	 W8l5KnIfe1be/vvkxExUoAxw7pJVJFF7g5L1m3f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 018/149] dpll: fix clock quality level reporting
Date: Mon, 22 Sep 2025 21:28:38 +0200
Message-ID: <20250922192413.341479234@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 70d99623d5c11e1a9bcc564b8fbad6fa916913d8 ]

The DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_EPRC is not reported via netlink
due to bug in dpll_msg_add_clock_quality_level(). The usage of
DPLL_CLOCK_QUALITY_LEVEL_MAX for both DECLARE_BITMAP() and
for_each_set_bit() is not correct because these macros requires bitmap
size and not the highest valid bit in the bitmap.

Use correct bitmap size to fix this issue.

Fixes: a1afb959add1 ("dpll: add clock quality level attribute and op")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Link: https://patch.msgid.link/20250912093331.862333-1-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index c130f87147fa3..815de752bcd38 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -173,8 +173,8 @@ static int
 dpll_msg_add_clock_quality_level(struct sk_buff *msg, struct dpll_device *dpll,
 				 struct netlink_ext_ack *extack)
 {
+	DECLARE_BITMAP(qls, DPLL_CLOCK_QUALITY_LEVEL_MAX + 1) = { 0 };
 	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
-	DECLARE_BITMAP(qls, DPLL_CLOCK_QUALITY_LEVEL_MAX) = { 0 };
 	enum dpll_clock_quality_level ql;
 	int ret;
 
@@ -183,7 +183,7 @@ dpll_msg_add_clock_quality_level(struct sk_buff *msg, struct dpll_device *dpll,
 	ret = ops->clock_quality_level_get(dpll, dpll_priv(dpll), qls, extack);
 	if (ret)
 		return ret;
-	for_each_set_bit(ql, qls, DPLL_CLOCK_QUALITY_LEVEL_MAX)
+	for_each_set_bit(ql, qls, DPLL_CLOCK_QUALITY_LEVEL_MAX + 1)
 		if (nla_put_u32(msg, DPLL_A_CLOCK_QUALITY_LEVEL, ql))
 			return -EMSGSIZE;
 
-- 
2.51.0



