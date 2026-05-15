Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BFB3CF67B;
	Fri, 15 May 2026 16:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862815; cv=none; b=l9bvOT0HgYvBFKWJCPorWSBA6XJTL/lWTJUIODeDuGIm+iUD6Ji4PkOzna4IrqF1UOi4rlToq3tZcXuT02djwAvr2BcHDPo44ZxuPqUE0iK2OLvzV5GdB32cmcs2ykHHgVNiA21VfTPuSIhaf+KzzTRXORlg2aASZzYU5ffJYjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862815; c=relaxed/simple;
	bh=z2MeJv/JfvhPGl631+65OWjJWFJacsH+MK91bSMvkaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+wqgrTamB6xuZQYQYBp8mxvdqqLFhKnbYlI7wcRwHQUSmFKgNX+bNk+NoUvDYFjtrkgyIdznKIKIjtMHR1HN+1UkZ/d8G036Yy2ANhzG4+W44JJ9B/2lWwn+h3H8CRSW4nPGDmlxt7J3RDVSLDfhA7eC5kYkZNzbMOCXaXCthg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvAqE+PU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvAqE+PU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DACEC2BCB0;
	Fri, 15 May 2026 16:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862815;
	bh=z2MeJv/JfvhPGl631+65OWjJWFJacsH+MK91bSMvkaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvAqE+PUhpPgysxkOjXNxqesAgeufEI9PjGMn9JLyEBE45s1CUAAgVW96WUGeyd7j
	 wmFCdEmENqVeQ+c485pFjFXIdAqdi2bzv46Vom2+niFx+CeiHf1PsChj3r5etVfiwG
	 q/0NP1WBzHDWKlB8DHFGXbuj/WiEuhJbBfJBV82g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Mayer <mmayer@broadcom.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 7.0 193/201] perf build: fix "argument list too long" in second location
Date: Fri, 15 May 2026 17:50:11 +0200
Message-ID: <20260515154702.761647688@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Mayer <mmayer@broadcom.com>

commit 97ab89686a9e5d087042dbe73604a32b3de72653 upstream

Turns out that displaying "RM $^" via quiet_cmd_rm can also upset the
shell and cause it to display "argument list too long".

Trying to quote $^ doesn't help.

In the end, *not* displaying the (potentially long) list of files is
probably the right thing to do for a "quiet" message, anyway. Instead,
let's display a count of how many files were removed. There is always
V=1 if more detail is required.

  TEST    linux/tools/perf/pmu-events/metric_test.log
  RM      ...634 orphan file(s)...
  LD      linux/tools/perf/util/perf-util-in.o

Also move the comment regarding xargs before the rule, so it doesn't
show up in the build output.

Signed-off-by: Markus Mayer <mmayer@broadcom.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/pmu-events/Build |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/pmu-events/Build
+++ b/tools/perf/pmu-events/Build
@@ -211,10 +211,10 @@ ifneq ($(strip $(ORPHAN_FILES)),)
 
 # Message for $(call echo-cmd,rm). Generally cleaning files isn't part
 # of a build step.
-quiet_cmd_rm  = RM      $^
+quiet_cmd_rm = RM      ...$(words $^) orphan file(s)...
 
+# The list of files can be long. Use xargs to prevent issues.
 prune_orphans: $(ORPHAN_FILES)
-	# The list of files can be long. Use xargs to prevent issues.
 	$(Q)$(call echo-cmd,rm)echo "$^" | xargs rm -f
 
 JEVENTS_DEPS += prune_orphans


