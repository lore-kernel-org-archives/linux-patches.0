Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA92415F1A;
	Tue, 21 Jul 2026 19:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662757; cv=none; b=u1Rv51lrDx3JlvNVZIVaZRnSBt5LXgOgn7mT7eKXAd5XitD+zJk641sOieh6TQhLbSjs6nNaWig2pDT2NbSfWoQ3+/cjzY4GUN+E8KalV2bMCy9NxInoMoKLmtmWJH703pZ2kbvryhHSd5cUVu+AtxPDHZ0LPRwBmNsSGlcWKzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662757; c=relaxed/simple;
	bh=2g9pYXMmzGzGKo+0LvNP1YwsKRZ0Psgcg8p+zEe6MOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBiWkPWVzqDEwMkQOL3suRNoArrREhEjilOQ5+4KhQR688C6K1X6aU3CAOJZHNB0MEFrPMtHNO7TIvFO9GJR+NTtDtBDtsN54auh0kk/1iDyRuf31+5k7nAdWEmj4TJyuVmWEKhsmPcZgAsE2yni3v0UFPKEs0ISN+Idcjvz/FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GM674UiB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GM674UiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B6B1F000E9;
	Tue, 21 Jul 2026 19:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662756;
	bh=l/K34tnmkgM4F0e19RxSxbb8eWlsoL7qFGe3lNQagUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GM674UiBkEpHiaokgdeShB8MVf65pG2qixuZXCRGuISqYTHaMdhuqkiTso/hlNHzS
	 0mt2FkD6d/Cl8/weAn/fXGHVG7F4fvoHshs9ETYdUWMTUrBz8uPOtcmg1jorVQTsX3
	 xdReFzB68NxBAUpcXyl8xn03UDO7HX5T8X8l9IG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0566/1276] perf machine: Use snprintf() for guestmount path construction
Date: Tue, 21 Jul 2026 17:16:49 +0200
Message-ID: <20260721152458.783406811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

[ Upstream commit fe63d3bca288c5bb983304efd5fc3a5ff3183403 ]

machines__findnew() and machines__create_guest_kernel_maps() use
sprintf() to build paths by prepending symbol_conf.guestmount.
Both write into PATH_MAX stack buffers, but guestmount comes from
user configuration and is not length-checked.  A guestmount path
at or near PATH_MAX causes a stack buffer overflow.

Switch to snprintf() with sizeof() to prevent overflow.  The
subsequent access()/fopen() calls will fail on a truncated path.

Fixes: a1645ce12adb6c9c ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 71d3d034ba095e..b1817634996964 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -289,7 +289,7 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
 	if ((pid != HOST_KERNEL_ID) &&
 	    (pid != DEFAULT_GUEST_KERNEL_ID) &&
 	    (symbol_conf.guestmount)) {
-		sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
+		snprintf(path, sizeof(path), "%s/%d", symbol_conf.guestmount, pid);
 		if (access(path, R_OK)) {
 			static struct strlist *seen;
 
@@ -1214,9 +1214,9 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 					 namelist[i]->d_name);
 				continue;
 			}
-			sprintf(path, "%s/%s/proc/kallsyms",
-				symbol_conf.guestmount,
-				namelist[i]->d_name);
+			snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
+				 symbol_conf.guestmount,
+				 namelist[i]->d_name);
 			ret = access(path, R_OK);
 			if (ret) {
 				pr_debug("Can't access file %s\n", path);
-- 
2.53.0



