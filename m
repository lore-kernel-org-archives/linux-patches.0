Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00014415F2F;
	Tue, 21 Jul 2026 18:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657636; cv=none; b=sV/4ug93UatDXx+G8VMChWC4kGQl8DeIQsWQQId11nbSPC7KNQNlmZIefTuPf/YBFZhI5VmZN8ADHMDrN7W+Fivgmdsnp+/dQ5kEwY3+w8GBrW30gTBvO6ki0/UxXyz01o7ROSGkTqQg8VfUw7g2f+dnlPyy4I9OQpkA4vW2008=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657636; c=relaxed/simple;
	bh=Zq3uhuqHpwsqCO1sT2amSohAxog9P77oh1uDiDGHwao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2rSFl+yJLilsZxjUhX+FK8rBSWvajtdLeDJ6NInZ6O4FE4++k6iqOMCXCZ6BZ13jpGTkjnhrQboDOOgjPS9HeeoZHfnIt4VgBzmcKNl818dJIBP8Jc++cFEUqXTzXJQRuljY8RwMwZQ7XRDf77fCev7hU7brktB7T7skaEk3D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2i5K5DeE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2i5K5DeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6735B1F000E9;
	Tue, 21 Jul 2026 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657634;
	bh=/qqGdXUsWmruGmGzLDA2MmglERjXrJwib2g+N0Gg4XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2i5K5DeE7fpzNqUsdGaiDFLF92iOa1YDgGoFQ+e+q3cb6At/ZmYmN5nlsUg3o2MYk
	 9h03Bqy9DjHoESEsHuzQg5tFLGjgtcVJVrt+iG6NdA+cgjDLMXE/rEsV21w0+84WwZ
	 BYlIobdHtu3LLxjEAQRbkIAsh6fDTUicd91mMax4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0795/1611] perf machine: Use snprintf() for guestmount path construction
Date: Tue, 21 Jul 2026 17:15:11 +0200
Message-ID: <20260721152533.269148013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 50f5f2b2ae530c..2ea5e6f3ae805b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -327,7 +327,7 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
 	if ((pid != HOST_KERNEL_ID) &&
 	    (pid != DEFAULT_GUEST_KERNEL_ID) &&
 	    (symbol_conf.guestmount)) {
-		sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
+		snprintf(path, sizeof(path), "%s/%d", symbol_conf.guestmount, pid);
 		if (access(path, R_OK)) {
 			static struct strlist *seen;
 
@@ -1239,9 +1239,9 @@ int machines__create_guest_kernel_maps(struct machines *machines)
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



