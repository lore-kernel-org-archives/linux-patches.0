Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A832C2D626;
	Fri, 24 Nov 2023 18:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUbQ5nGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4182C433C8;
	Fri, 24 Nov 2023 18:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851264;
	bh=aqMaudOxfcL+aVftteqcVJxCdE3QStICEWx1EnVjECA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUbQ5nGd0Vz/dVs+Z8TxmRc23xHSwRQJ4BTbpG36at9he1ZmFU8Fm9Vm3W5MeowEa
	 QpC4HB0A/kNSOgzucK8GFFe1L0VXeajXrB+b4p3rQ2Bxg5si29PbawYXHBOfLjf6rC
	 SfYjs30555mw5nZ27uKzh9fCe+01wbuL7mE15hJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florent Revest <revest@chromium.org>,
	Alexey Izbyshev <izbyshev@ispras.ru>,
	David Hildenbrand <david@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ayush Jain <ayush.jain3@amd.com>,
	Greg Thelen <gthelen@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	KP Singh <kpsingh@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
	Topi Miettinen <toiwoton@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.5 353/491] mm: make PR_MDWE_REFUSE_EXEC_GAIN an unsigned long
Date: Fri, 24 Nov 2023 17:49:49 +0000
Message-ID: <20231124172035.170441869@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florent Revest <revest@chromium.org>

commit 0da668333fb07805c2836d5d50e26eda915b24a1 upstream.

Defining a prctl flag as an int is a footgun because on a 64 bit machine
and with a variadic implementation of prctl (like in musl and glibc), when
used directly as a prctl argument, it can get casted to long with garbage
upper bits which would result in unexpected behaviors.

This patch changes the constant to an unsigned long to eliminate that
possibilities.  This does not break UAPI.

I think that a stable backport would be "nice to have": to reduce the
chances that users build binaries that could end up with garbage bits in
their MDWE prctl arguments.  We are not aware of anyone having yet
encountered this corner case with MDWE prctls but a backport would reduce
the likelihood it happens, since this sort of issues has happened with
other prctls.  But If this is perceived as a backporting burden, I suppose
we could also live without a stable backport.

Link: https://lkml.kernel.org/r/20230828150858.393570-5-revest@chromium.org
Fixes: b507808ebce2 ("mm: implement memory-deny-write-execute as a prctl")
Signed-off-by: Florent Revest <revest@chromium.org>
Suggested-by: Alexey Izbyshev <izbyshev@ispras.ru>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ayush Jain <ayush.jain3@amd.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: Topi Miettinen <toiwoton@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/prctl.h       | 2 +-
 tools/include/uapi/linux/prctl.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 3c36aeade991..9a85c69782bd 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -283,7 +283,7 @@ struct prctl_mm_map {
 
 /* Memory deny write / execute */
 #define PR_SET_MDWE			65
-# define PR_MDWE_REFUSE_EXEC_GAIN	1
+# define PR_MDWE_REFUSE_EXEC_GAIN	(1UL << 0)
 
 #define PR_GET_MDWE			66
 
diff --git a/tools/include/uapi/linux/prctl.h b/tools/include/uapi/linux/prctl.h
index 3c36aeade991..9a85c69782bd 100644
--- a/tools/include/uapi/linux/prctl.h
+++ b/tools/include/uapi/linux/prctl.h
@@ -283,7 +283,7 @@ struct prctl_mm_map {
 
 /* Memory deny write / execute */
 #define PR_SET_MDWE			65
-# define PR_MDWE_REFUSE_EXEC_GAIN	1
+# define PR_MDWE_REFUSE_EXEC_GAIN	(1UL << 0)
 
 #define PR_GET_MDWE			66
 
-- 
2.43.0



