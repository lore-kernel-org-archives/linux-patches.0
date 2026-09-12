Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9AD3FF1AE;
	Sat, 12 Sep 2026 12:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217056; cv=none; b=Tydyl6KurGJBzhNVlAaB0ah1xpjWi8ihMpnRBYnWdcdjdRU6TBq6pe5+ckBccgEQNRsRsCT6Av6pCmbBBW8X+Yo6WFp6yC43mQLnNxeBDoFC0E7xlIt3ymWKbMnpi02FrigZ/H7g9z/9Y1Qm+RbpzAfnziVp8b4V0G7IkT/PBe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217056; c=relaxed/simple;
	bh=G+eGN5eY0dOAk/HtsOhO4W28e123DDh+dxddG6Od444=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLyvB71u6in2AiMziqaNZR6guWogz8qHWQaqKKkvJ4OyfMBJAUwvzhLPerniX3YNxQC1D0PUfnNfwK3G8mr6h3Wxvl4uUhDWGvA9rbsLSPOktZOLDoa3E///81E8EWdvJ0DdTIPg9i+QpAeHN1v1cyG9VSWhR9OyyTRjksRLjiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YY+vuXkJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YY+vuXkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B611F000FF;
	Sat, 12 Sep 2026 12:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217055;
	bh=M/OeWxGfOppPHs/TEfSSeGRYt2V/u2MgiZTNxIF+pr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YY+vuXkJyiYA+4LirZyhKZB39MWqTFBKLNmhCKkDAMjQCpS8ydCRm0NMoWePWkVRR
	 C0EOMEDQj11rdC73wKBhwLUiYkApP7Bh1jcl0Esxn4+9TX6fIlBN3gTCCbJylL43Bw
	 Yz3vyardm2gtNDOtwsINohVyqDFoOPGabR2WU+Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0836/1376] perf machine: Check snprintf truncation for guest kallsyms path
Date: Sat, 12 Sep 2026 08:54:22 +0200
Message-ID: <20260912065626.180234537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit d04ef71492fad7230d474efe33d05f4c0563d409 ]

machines__create_guest_kernel_maps() builds the guest kallsyms path
with snprintf() without checking the return value.  A truncated path
could pass the access() check if a prefix directory happens to contain
a file named "kallsyms", leading to the wrong file being used for
symbol resolution.

Check for truncation and skip the directory.

Fixes: a1645ce12adb ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index a958184d3bb38..77050eff8fcb5 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1223,9 +1223,14 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 				free(namelist[i]);
 				continue;
 			}
-			snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
-				 symbol_conf.guestmount,
-				 namelist[i]->d_name);
+			if (snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
+				     symbol_conf.guestmount,
+				     namelist[i]->d_name) >= (int)sizeof(path)) {
+				pr_debug("Guest kallsyms path too long for %s. Skipping.\n",
+					 namelist[i]->d_name);
+				free(namelist[i]);
+				continue;
+			}
 			if (access(path, R_OK)) {
 				pr_debug("Can't access file %s\n", path);
 				free(namelist[i]);
-- 
2.53.0



