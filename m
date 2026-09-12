Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C0633993;
	Sat, 12 Sep 2026 09:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204362; cv=none; b=XnGPL+611J/fc5eL2uz7OY988Oldgn06fuVYfYXJsbmsk1DqcA6tGejwdM60o7rfKNpSXdMnGL5uY5t16DXjz+IwZrGFkWnnrAda7DFeTJapzO9UvwdvE4Lo9zI97fTVoxkIT3DHRouoNSfREn9GZH2fr6C/dovO1De6j+AMcPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204362; c=relaxed/simple;
	bh=UMhVXyhWL3vxpB6oL9OOqSgqBvu/3RWFqS29kqRbk9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rLmRijgqzh6LGzewNW+G/kh4OLi5vhoMS6uxoGZkHovLOlyGnopu7Z95UKjbyBhvySgyDyZdUPgntejt3acqFkLYRtf/34B1jTamK2tfoew/FaO3RfFRvOc5EXQCOcXtHbyf3a+sqwLkKzxvzHD6v1BDjfVTZO7Y6TIbEyg8kHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAxThOUa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAxThOUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86941F000FF;
	Sat, 12 Sep 2026 09:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204360;
	bh=28LY+xdDWuehByDDce8t/w1wQ672ZVphKj4UAs4aN7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nAxThOUaNl1w9/8MQuK1XmsXcRzVT2tjcsnnkwhiOG2AjLIMljQVouvVszjbV3xYC
	 n5qif3FkY1U/SKMp/B1EPvMO/1ZuJ6n9wfcprVNJAVxvfoFZ1QhEbKH9ulFI6ramDm
	 Kv2dujDlxGjCMTScG646Y9QMUudDpaNswAwT3TlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kulikov <nikolayof23@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1595/1815] mlxbf-bootctl: fix the build error with FIELD_PREP()
Date: Sat, 12 Sep 2026 08:55:45 +0200
Message-ID: <20260912065726.435556467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kulikov <nikolayof23@gmail.com>

[ Upstream commit 46b14c6f11f558362391e308f4f184ee867ef58f ]

rsh_log_store() calls the FIELD_PREP() macro without including the
required header file, resulting a build error:

  CC      drivers/platform/mellanox/mlxbf-bootctl.o
drivers/platform/mellanox/mlxbf-bootctl.c: In function ‘rsh_log_store’:
drivers/platform/mellanox/mlxbf-bootctl.c:429:16: error: implicit declaration of function ‘FIELD_PREP’ [-Wimplicit-function-declaration]
  429 |         data = FIELD_PREP(MLXBF_RSH_LOG_TYPE_MASK, MLXBF_RSH_LOG_TYPE_MSG);
      |                ^~~~~~~~~~

Fix this by including the <linux/bitfield.h> file.

Fixes: e9d1b2d0f7d0 ("mlxbf-bootctl: Add sysfs file for BlueField boot log")
Signed-off-by: Nikolay Kulikov <nikolayof23@gmail.com>
Link: https://patch.msgid.link/20260810-mellanox_fix_implicit_declaration-v1-1-352e647b8f28@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-bootctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/mellanox/mlxbf-bootctl.c b/drivers/platform/mellanox/mlxbf-bootctl.c
index f67c7f56ab2b7..9ddc7fa1a9732 100644
--- a/drivers/platform/mellanox/mlxbf-bootctl.c
+++ b/drivers/platform/mellanox/mlxbf-bootctl.c
@@ -10,6 +10,7 @@
 
 #include <linux/acpi.h>
 #include <linux/arm-smccc.h>
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/if_ether.h>
 #include <linux/iopoll.h>
-- 
2.53.0



