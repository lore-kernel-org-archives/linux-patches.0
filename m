Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFCE2E8DF4;
	Sun, 26 Oct 2025 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490203; cv=none; b=MVSqeF/FphXw1HwMm0v3ezCsu2jA7ktoGOKVlBIvpnjtgWGi10RW/GRxrT66reu4f1FKDjormZTxVTTJR08Inxn70AUsrBQvp1oOFLwiaubiIuykv9ci2eFVY5oFxxwFh1NqtozpWQRzvSL2Ma9mudU3Nt8aiB0bs+cOPAzDZQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490203; c=relaxed/simple;
	bh=XP890OVKVM31rpBJlWx+hnuTdh3L1Z9JtBrq0v/RY9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A+FNzBaoGAEDDPaffmWgi+LLK6GsYfMiwGGtoq4gr/IVLZ2hFVzSboQM3/fTLg0vlo4yosNPg32f0bVBZlFSqjVZzqS+IO0xfde8jBlZZw0xAniFn3TdK0qoWQzUvYOl9r70ad1L3m3gerkwhtHVNaa6oOdgY2iivG65xAagyJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mgY7fePb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mgY7fePb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76246C4CEF1;
	Sun, 26 Oct 2025 14:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490203;
	bh=XP890OVKVM31rpBJlWx+hnuTdh3L1Z9JtBrq0v/RY9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgY7fePbIFAslsOAyxqmWth6NbAUZUIPznnIUpy57gWxomXH2RuNCO8Kb6FLN/jre
	 4IyH4O/duQPjc8yBXYhTAGeWf2aE8SsqL9qvaGl57N0PkicPKfykbT6LjdfTwF2O/J
	 DHX+vOH0ng2uLI4kilwKmtqjewHSvhif8OXxi5JAJ7FFiWoqqDn1fcf42iK+kKKsoG
	 J57WiYGoPfjeChHuOCT4+C3CQu11ySsG4mIkWnbrSv7Vucv+A+lsxoRPa60whq4QNV
	 XKfgwIM0HubN8uVX7fUTuGii9ocIP7unnzCYeib3yhFI8bCup5rz0Keu6np52okHOb
	 8MhHYMklwp8gQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Randall P. Embry" <rpembry@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>,
	ericvh@kernel.org,
	lucho@ionkov.net,
	v9fs@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17-5.4] 9p: sysfs_init: don't hardcode error to ENOMEM
Date: Sun, 26 Oct 2025 10:48:41 -0400
Message-ID: <20251026144958.26750-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Randall P. Embry" <rpembry@gmail.com>

[ Upstream commit 528f218b31aac4bbfc58914d43766a22ab545d48 ]

v9fs_sysfs_init() always returned -ENOMEM on failure;
return the actual sysfs_create_group() error instead.

Signed-off-by: Randall P. Embry <rpembry@gmail.com>
Message-ID: <20250926-v9fs_misc-v1-3-a8b3907fc04d@codewreck.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – the change makes `v9fs_sysfs_init()` propagate the real failure
code from sysfs instead of always reporting `-ENOMEM`, which corrects
user-visible error reporting with negligible risk.

- `fs/9p/v9fs.c:599-609` now stores the `sysfs_create_group()` return
  value in `ret` and hands it back unchanged; previously every failure
  was coerced to `-ENOMEM`, masking causes such as `-EEXIST` or
  `-EINVAL`.
- `init_v9fs()` already bubbles that return value to the module loader
  (`fs/9p/v9fs.c:677-690`), so the bad errno currently confuses anyone
  diagnosing why the filesystem failed to load; accurate errnos aid
  automated tooling and human debugging.
- No other behaviour changes: the failure path still drops the kobject,
  and successful initialisation and cleanup remain identical, so
  regression risk is minimal.

Given it fixes incorrect error propagation in a contained subsystem
routine with no interface churn, it aligns well with stable backport
criteria.

 fs/9p/v9fs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 714cfe76ee651..a59c26cc3c7d9 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -597,13 +597,16 @@ static const struct attribute_group v9fs_attr_group = {
 
 static int __init v9fs_sysfs_init(void)
 {
+	int ret;
+
 	v9fs_kobj = kobject_create_and_add("9p", fs_kobj);
 	if (!v9fs_kobj)
 		return -ENOMEM;
 
-	if (sysfs_create_group(v9fs_kobj, &v9fs_attr_group)) {
+	ret = sysfs_create_group(v9fs_kobj, &v9fs_attr_group);
+	if (ret) {
 		kobject_put(v9fs_kobj);
-		return -ENOMEM;
+		return ret;
 	}
 
 	return 0;
-- 
2.51.0

