Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF5139022B;
	Sat, 12 Sep 2026 19:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242929; cv=none; b=truKkzpoBWZ+yTYybz0thJDwjzmze8pO1wjKT5bcwOk4TXSl7eQH6Bnt5Sl569jDGbRT/FK0cNbuZriniAM7CKSZz3Z7zCVVPqXjG+88H5ZMKjH42H3uKWrDBgaJSKWAebPnzmG86ffUOpBRlSM1WcBO4SFXOtizqwh1KUJ1j8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242929; c=relaxed/simple;
	bh=vPGEHrQi4YbokJU0UTXlSsqTz1pwMo39CLJqitf3zgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mznQsPlKzm73G/6+dJgkqiy6H8ikD/Lv4K5vXeUVsH5WfmGQ3Mpm95kYBXRcwxztrDlVadSqlKLmtxV+i/DZsxFfZ5aTppIIx+vw23vlfrzdBQU6DUGHPk9cNcgw9gbFu534DHsFTT9mSShuKvTDTP+rPOmU+LfHwvNgnU1HYkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHuO42ex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHuO42ex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015551F000FF;
	Sat, 12 Sep 2026 19:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242927;
	bh=8SW/ZPY8Lc+uPOifgs49QwmsldulEeymXdvIWBuSy/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHuO42exspHpxGlv2g7PDPR66zsCYn1OBdhR4nKnIZoT7IyGzu716TwvMLfeetUy8
	 Vt4Z46chYI2LCypunUAPGtPECeMNesLW/kQ58kEr97ji2xcpHZzs7QrKpMMV0H3YaU
	 mPIn6X1zy2eejwV++1d8dxrLdmd9JIQ1sYRzpLZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gou Hao <gouhao@uniontech.com>,
	jiazhenyuan <jiazhenyuan@uniontech.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 576/798] powerpc/smp: add NULL guard for cause_ipi in smp_muxed_ipi_message_pass
Date: Sat, 12 Sep 2026 09:03:24 +0200
Message-ID: <20260912065530.333293260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gou Hao <gouhao@uniontech.com>

[ Upstream commit 5aabc192702defb8950e7c81b05c3f4ca8ee43ec ]

smp_muxed_ipi_message_pass() calls smp_ops->cause_ipi() without
checking whether it has been set.

On platforms using muxed IPI (e.g. powernv/pseries), smp_ops->cause_ipi
is initialized to NULL in the static smp_ops and only assigned during
the platform smp_probe() handler.  If the IPI subsystem fails to
initialize -- for example when xive_init_ipis() fails and
xive_smp_probe() returns an error -- the probe handler returns early
and cause_ipi is never set.  Any subsequent IPI send (e.g.
arch_smp_send_reschedule()) would dereference the NULL pointer.

Add a NULL check to avoid the crash in that situation.

Fixes: 23d72bfd8f9f ("powerpc: Consolidate ipi message mux and demux")
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260727104215.184786-6-gouhao@uniontech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index cf99f57aed822..35747e9e8f18c 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -270,6 +270,9 @@ void smp_muxed_ipi_set_message(int cpu, int msg)
 
 void smp_muxed_ipi_message_pass(int cpu, int msg)
 {
+	if (!smp_ops->cause_ipi)
+		return;
+
 	smp_muxed_ipi_set_message(cpu, msg);
 
 	/*
-- 
2.53.0



