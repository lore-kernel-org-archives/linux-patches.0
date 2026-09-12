Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95F51C5799;
	Sat, 12 Sep 2026 18:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239392; cv=none; b=rpDIQDP0ofjgRAKFUGcEsqWDDDQyMKhQHuTgEWq4Es+5PcS7a8R1iR+9QfxpWXVuKvydPJpuwo36gxd48rXERwVIiQ3J2/tfQCgENkY5Ex4sRUWGQyg2VrCI2tXyH6ZFkuY654Hfj22lRSrHxquc6cPd3p7UBYjcgV8ehH6AjBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239392; c=relaxed/simple;
	bh=/i4kdKn4wAe0DNM/+nptJ6nfv1G4nUk22dDyAdUc4QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTNqp/jQLi5f/vTln9tRvJujxoIltX8byj/Uq3iId4FmGH2vksoxqsheUU1/zsILumL5ujJbat5y5sg1JGquifBl8HoLVTVK0QxqJGKDTdEtmNoRd+idnwgykq9v1G1yG5z6ZHdo6xVrzUhXChMGNlg8AP1L5N0e4yHVkeiDpWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4xkBm4d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4xkBm4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B07E1F000FF;
	Sat, 12 Sep 2026 18:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239391;
	bh=bpwKQ2oX7Dgezznyvz9jk4ZbV2lbwl91HjMrAYDu8gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4xkBm4deCPv13XAe9dcOsjhzd7gFGhobDgeufpzJhTKbuIo+pSIDfOezTvM9Q1iF
	 t2m1KSDMUqkOMM6EoRp1ulnPRZ00VqgZManY/pF56WfHsjQREay0Jxi6AkkknjeQuZ
	 Wo2bwPhuc5qPVuVvs9G5Kymzuej2arPUXqxs88oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 655/935] perf machine: Use snprintf() for guestmount path construction
Date: Sat, 12 Sep 2026 09:01:25 +0200
Message-ID: <20260912065541.864930540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: cc6abe0012bf ("perf machine: Check snprintf truncation in machines__findnew()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 16df0e96c9ed8..6c10a902cafa5 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -348,7 +348,7 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
 	if ((pid != HOST_KERNEL_ID) &&
 	    (pid != DEFAULT_GUEST_KERNEL_ID) &&
 	    (symbol_conf.guestmount)) {
-		sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
+		snprintf(path, sizeof(path), "%s/%d", symbol_conf.guestmount, pid);
 		if (access(path, R_OK)) {
 			static struct strlist *seen;
 
@@ -1261,9 +1261,9 @@ int machines__create_guest_kernel_maps(struct machines *machines)
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



