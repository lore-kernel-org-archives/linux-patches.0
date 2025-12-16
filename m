Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A561734D3BA;
	Tue, 16 Dec 2025 11:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885315; cv=none; b=fobvmec4sjBFiX6R07sya6gaZVwr4t7i16ZBQItsH++HBjhuUuF/9Y6g3iXMt/qq7fu6mRikKw8CyuOPmVZ/YwXQyfloCoUkpyM56O9kh/pGDjsqKb0yUy7Ho6bnR4RV3jhHoyBA94F7rgYIir+gnluyDUjEx4XJYhLl9kRM77o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885315; c=relaxed/simple;
	bh=76RrOdDxolX6wmw6xsnwdPTzgoi+Pcy04igDCkvuS8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrCrLBrvAkVbaaXAMGMsO4Nr7i1zsMq2zsWWJS53M7W3lF13TJMWxKzcK4jAnURVSoaLAtBG8+qcdJSqPqgptzEUE3gSi2KkJ9xgHxBEQoOLRgNCg7C0fcohREEW9Muqv2kqEUgPgNE4id14E+ZkgZYC74SeU5Fu8/FcPwdjhDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5MXMyKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5MXMyKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B126FC4CEF1;
	Tue, 16 Dec 2025 11:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885315;
	bh=76RrOdDxolX6wmw6xsnwdPTzgoi+Pcy04igDCkvuS8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5MXMyKCBS18Dyq34S3Xoy/8j3QKS7HGUAol1tZLbiXmAoPoahQaCWJpLWdyeN21M
	 xi1nTmXB9Hxm15sNok0Y1+vmC3vcjADttvSD/ULaqBuV3+Sp43KSilfbUIhAEiP++J
	 EGzT3ABDVSjPCtQrrOlM7hEk+yHq8xH1Yn21oiZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 069/507] tty: introduce tty_port_tty guard()
Date: Tue, 16 Dec 2025 12:08:30 +0100
Message-ID: <20251216111348.042883962@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit e8398b8aed50382c21fcec77e80a5314e7c45c25 ]

Having this, guards like these work:
  scoped_guard(tty_port_tty, port)
    tty_wakeup(scoped_tty());

See e.g. "tty_port: use scoped_guard()" later in this series.

The definitions depend on CONFIG_TTY. It's due to tty_kref_put().
On !CONFIG_TTY, it is an inline and its declaration would conflict. The
guards are not needed in that case, of course.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20250814072456.182853-3-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: d55f3d2375ce ("tty: serial: imx: Only configure the wake register when device is set as wakeup source")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tty_port.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/tty_port.h b/include/linux/tty_port.h
index 332ddb93603ec..660c254f1efe5 100644
--- a/include/linux/tty_port.h
+++ b/include/linux/tty_port.h
@@ -270,4 +270,18 @@ static inline void tty_port_tty_vhangup(struct tty_port *port)
 	__tty_port_tty_hangup(port, false, false);
 }
 
+#ifdef CONFIG_TTY
+void tty_kref_put(struct tty_struct *tty);
+__DEFINE_CLASS_IS_CONDITIONAL(tty_port_tty, true);
+__DEFINE_UNLOCK_GUARD(tty_port_tty, struct tty_struct, tty_kref_put(_T->lock));
+static inline class_tty_port_tty_t class_tty_port_tty_constructor(struct tty_port *tport)
+{
+	class_tty_port_tty_t _t = {
+		.lock = tty_port_tty_get(tport),
+	};
+	return _t;
+}
+#define scoped_tty()	((struct tty_struct *)(__guard_ptr(tty_port_tty)(&scope)))
+#endif
+
 #endif
-- 
2.51.0



