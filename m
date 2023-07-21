Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A26200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BECC433C8;
	Fri, 21 Jul 2023 19:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966165;
	bh=ar473mVnH4NneQ1Bo/csg90mPu9i/1WyENf8hgrdOkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIs/fgrx+gnszgEORKdUH8PlLjzbPjRtzVKS2kuaVdc9PxK8bpy/JpWQlEi3Y7zS2
	 UTShl6o2ITpr/aYha1zZWtqkbnRlk9lu9WhNdSGd6ezbsy5KFpFNgyyiV+CUuhJcyu
	 a4wNW6MMagY65SxtqJvTS/McGllQORJZHrWQBiSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/532] ACPI: utils: Fix acpi_evaluate_dsm_typed() redefinition error
Date: Fri, 21 Jul 2023 18:02:31 +0200
Message-ID: <20230721160627.750287721@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 2c5a06e5505a716387a4d86f1f39de506836435a ]

acpi_evaluate_dsm_typed() needs to be gaurded with CONFIG_ACPI to avoid
a redefintion error when the stub is also enabled.

In file included from ../drivers/bluetooth/btintel.c:13:
../include/acpi/acpi_bus.h:57:1: error: redefinition of 'acpi_evaluate_dsm_typed'
   57 | acpi_evaluate_dsm_typed(acpi_handle handle, const guid_t *guid,..
      | ^~~~~~~~~~~~~~~~~~~~~~~
In file included from ../drivers/bluetooth/btintel.c:12:
../include/linux/acpi.h:967:34: note: previous definition of
'acpi_evaluate_dsm_typed' with type 'union acpi_object *(void *,
const guid_t *, u64,  u64,  union acpi_object *, acpi_object_type)'
{aka 'union acpi_object *(void *, const guid_t *, long long unsigned int,
long long unsigned int,  union acpi_object *, unsigned int)'}
  967 | static inline union acpi_object
*acpi_evaluate_dsm_typed(acpi_handle handle,

Fixes: 1b94ad7ccc21 ("ACPI: utils: Add acpi_evaluate_dsm_typed() and acpi_check_dsm() stubs")
Signed-off-by: Kiran K <kiran.k@intel.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/acpi_bus.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index e9c7d7b270e73..7a85ae6b7b005 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -52,7 +52,7 @@ bool acpi_dock_match(acpi_handle handle);
 bool acpi_check_dsm(acpi_handle handle, const guid_t *guid, u64 rev, u64 funcs);
 union acpi_object *acpi_evaluate_dsm(acpi_handle handle, const guid_t *guid,
 			u64 rev, u64 func, union acpi_object *argv4);
-
+#ifdef CONFIG_ACPI
 static inline union acpi_object *
 acpi_evaluate_dsm_typed(acpi_handle handle, const guid_t *guid, u64 rev,
 			u64 func, union acpi_object *argv4,
@@ -68,6 +68,7 @@ acpi_evaluate_dsm_typed(acpi_handle handle, const guid_t *guid, u64 rev,
 
 	return obj;
 }
+#endif
 
 #define	ACPI_INIT_DSM_ARGV4(cnt, eles)			\
 	{						\
-- 
2.39.2



