Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A80E2EE262;
	Tue, 31 Mar 2026 16:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974966; cv=none; b=X6OmKeUnq3hot3deqc1UYQ4fFHKnjMW5MRnZ+J0HBqKXR5vOuPN9c2jv4Yoa1YmcOaZZvU+b3MA2WsWvcTEjlXI833mPPP6nOzgBrKBP+iYMk0gyd2L+LoKOQcL2w4KSaaQdW6sDMpmog0YYOStMAnBzp5tQKZic1dyihLLjrc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974966; c=relaxed/simple;
	bh=nqrYokc5Zkab492cr05z2V9VU+7occ06VYBr1kzQtJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tNnOAQrXPpknUdiVXr4XBytf9gSmTFuShnG3M6zpcOoK7OFSkvpP5tEQ4m+ryKbOh0i1xeXsKkGBcn5Yijdlb+Bw38zP6QDxIPljsH4UkswNkPYHkqLz0vSZwKRMew7GQcL17SNd5R8phAMU66dYhJmfYD2yhlVJ2ZgyY3JE0lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ft4Xlmh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ft4Xlmh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC5EC19423;
	Tue, 31 Mar 2026 16:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974966;
	bh=nqrYokc5Zkab492cr05z2V9VU+7occ06VYBr1kzQtJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ft4Xlmh7i1elf4pECsJjEDuLaM1B/vYpAuV0v3Z46Ip6IsT3olDtoK5VdpiGFXIsk
	 qFdSMdLW7qebs2pcU0mxvGa4sNAfB1qJNmDfcARdRvOoIM1zW+pbFANFtjq1PQym2t
	 rTsOCkUpYccEeCD4oaa3v2G5r1EJZ9DrXyRx1aF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 112/342] platform/x86: lenovo: wmi-gamezone: Drop gz_chain_head
Date: Tue, 31 Mar 2026 18:19:05 +0200
Message-ID: <20260331161803.133416040@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 5a3955f3602950d1888df743a5b1889e43b5cb60 ]

The gz_chain_head variable has been unused since the driver's initial
addition to the tree. Its use was eliminated between v3 and v4 during
development but due to the reference of gz_chain_head's wait_list
member, the compiler could not warn that it was unused.

After a (tip) commit ("locking/rwsem: Remove the list_head from struct
rw_semaphore"), which removed a reference to the variable passed to
__RWSEM_INITIALIZER(), certain configurations show an unused variable
warning from the Lenovo wmi-gamezone driver:

  drivers/platform/x86/lenovo/wmi-gamezone.c:34:31: warning: 'gz_chain_head' defined but not used [-Wunused-variable]
     34 | static BLOCKING_NOTIFIER_HEAD(gz_chain_head);
        |                               ^~~~~~~~~~~~~
  include/linux/notifier.h:119:39: note: in definition of macro 'BLOCKING_NOTIFIER_HEAD'
    119 |         struct blocking_notifier_head name =                    \
        |                                       ^~~~

Remove the variable to prevent the warning from showing up.

Fixes: 22024ac5366f ("platform/x86: Add Lenovo Gamezone WMI Driver")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://patch.msgid.link/20260313-lenovo-wmi-gamezone-remove-gz_chain_head-v1-1-ce5231f0c6fa@kernel.org
[ij: reorganized the changelog]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lenovo/wmi-gamezone.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/platform/x86/lenovo/wmi-gamezone.c b/drivers/platform/x86/lenovo/wmi-gamezone.c
index 381836d29a964..c7fe7e3c9f179 100644
--- a/drivers/platform/x86/lenovo/wmi-gamezone.c
+++ b/drivers/platform/x86/lenovo/wmi-gamezone.c
@@ -31,8 +31,6 @@
 #define LWMI_GZ_METHOD_ID_SMARTFAN_SET 44
 #define LWMI_GZ_METHOD_ID_SMARTFAN_GET 45
 
-static BLOCKING_NOTIFIER_HEAD(gz_chain_head);
-
 struct lwmi_gz_priv {
 	enum thermal_mode current_mode;
 	struct notifier_block event_nb;
-- 
2.51.0



