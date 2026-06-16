Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70E22F12AE;
	Tue, 16 Jun 2026 18:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632900; cv=none; b=ozxhcNzsvI5BZUBKvBIt+exZ1bWom5TiInImjyxsmcS3qMQ3vR/ErGbhrB7HRSj2thbMcKX75FUylnD6AEoM/h8fG6tXylr5s/0ghmwm5qdwwP8KL831k0R42bRz5Ii+n3gQcUbS/y9CdVMM9d9JsLgfZuk/W0nqwdPlAEyMFBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632900; c=relaxed/simple;
	bh=cU0bf/W7MPemTzRSOprbh5VCgGb0dZZLGdtuQbU5a0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwF4/0NqHeK0+RTE03N6guir64+WK5txIjbbAX1sp6wNeAalGn7ph92gEiZNouiOhCE1AB/uIHrfOUr/V0nmONnxrivqQK65MgCRGuagv68oYx7bG4wFKWFMx3gnfkNRK/MXqkUkjEdnlKqcWbd0NjB15EiQQIx5azs4QyiJB6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0t7gBBYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0t7gBBYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626681F000E9;
	Tue, 16 Jun 2026 18:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632899;
	bh=wXA6E+7/MOOuH1TQFA3ZJc9PhRyP1TbYUJf3aVhbj1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0t7gBBYCvQY0iu+lBgKw2Mf1hlIYdorKMpCpwgRNOZY/We9Z93GM/aSryyfoyhF4A
	 w4kv+EVbjz1+G8UGaf0QYbNuaFwhsFmj1/7CtGql/ZAFXBfrJhvhq2Jciczi/ppEBC
	 /QIdK3DEk1IkO9XkplIOyVzbdSjvaGaM9te0NITU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.1 498/522] tools build: Add 3-component logical version comparators
Date: Tue, 16 Jun 2026 20:30:45 +0530
Message-ID: <20260616145149.073087902@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit a9b451509565d40a5ca3b41c39a2b758cdbc5355 upstream

The next cset needs to compare if a flex version is greater or
equal/less than another, but since there is no canonical, generally
available way to compare versions in the command line (sort -V, yeah,
but...), just use awk to canonicalize the versions like is also done in
scripts/rust_is_available.sh.

There was a problem spotted in linux-next where a bashism, here
documents, aka the '<<<' stdin redirector, for strings to be used as the
stdin for awk. Use $(shell echo | awk ...) instead.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/scripts/utilities.mak |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/tools/scripts/utilities.mak
+++ b/tools/scripts/utilities.mak
@@ -177,3 +177,23 @@ $(if $($(1)),$(call _ge_attempt,$($(1)),
 endef
 _ge_attempt = $(or $(get-executable),$(call _gea_err,$(2)))
 _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
+
+# version-ge3
+#
+# Usage $(call version-ge3,2.6.4,$(FLEX_VERSION))
+#
+# To compare if a 3 component version is greater or equal to another, first use
+# was to check the flex version to see if we can use compiler warnings as
+# errors for one of the cases flex generates code C compilers complains about.
+
+version-ge3 = $(shell echo "$(1).$(2)" | awk -F'.' '{ printf("%d\n", (10000000 * $$1 + 10000 * $$2 + $$3) >= (10000000 * $$4 + 10000 * $$5 + $$6)) }')
+
+# version-lt3
+#
+# Usage $(call version-lt3,2.6.2,$(FLEX_VERSION))
+#
+# To compare if a 3 component version is less thjan another, first use was to
+# check the flex version to see if we can use compiler warnings as errors for
+# one of the cases flex generates code C compilers complains about.
+
+version-lt3 = $(shell echo "$(1).$(2)" | awk -F'.' '{ printf("%d\n", (10000000 * $$1 + 10000 * $$2 + $$3) < (10000000 * $$4 + 10000 * $$5 + $$6)) }')


