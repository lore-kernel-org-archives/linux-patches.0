Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0369637E5C4;
	Sat, 12 Sep 2026 10:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209480; cv=none; b=RIu0knMa13VNEpopA0IvaDjOfU4owPuXH+/iCvuF76SKId827Wso41wfVMMMWuvqf9Tcp9Pte5MyN5xkVCRCPSwoD5FGmUX02oiiRb/B7xh7EEHWJaITdi4aobdSNFJnwMaczpCB8OTk0FJeK50taZ5F6GtsmNMkm3eCo2Yzdfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209480; c=relaxed/simple;
	bh=I6s2qi1er+8N9FFL3rN/5uHJjg+fSW4P5flDM8ayTWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bo6n285iihDPITiNMx/aHwITP+6SlgjHthub6mIi5I1Hsc6d8ZSPWE7PvuY6CxCUejQnnEyxyf9IIcPb/DuYyYEoKyVVXA1UKKS+KxuPeCT6M4yclu4yZEQeN+4kt8CRzwTuymyoVuRwuyK/IGq/Lwi68vHIoiSMZd6EhmEQWVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCn3fR9l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCn3fR9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D671F000FF;
	Sat, 12 Sep 2026 10:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209478;
	bh=xf5obgEscASnXOdjnenne1/6wcA7XgknRxss/Wa92C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tCn3fR9l4Y72ZQX/7oZ2ZYlnESIAaNJi8VSPHbFz3so4+IPeWondOVoB9tvn5HE+I
	 A5xrQ++bZHhH+aIiHkw700NIxithI72g/Q829sGJMofUJ1PKn+981aRAz8MB+mgTn6
	 Fm5dlUAzFb1X/3jQd2CkBbmn2IhHEfTs5bPLCaYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0786/1518] perf machine: Check snprintf truncation for guest kallsyms path
Date: Sat, 12 Sep 2026 08:49:15 +0200
Message-ID: <20260912065641.216644436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5deeb41753717..cb138d1bdd7b9 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1248,9 +1248,14 @@ int machines__create_guest_kernel_maps(struct machines *machines)
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



