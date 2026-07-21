Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18D53C1098;
	Tue, 21 Jul 2026 21:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669505; cv=none; b=A0BuNTDnzMQxEc3HUQJWDItWAtbqvhSKxnTrbRthEalVEn5cf/XgfwH0ZJzRnJglsZLgVGMI/aMFD0wN6NRTv1D1F0Hwu1siUoiUKgb01EN76qjoa+DCGXjdliWVgwebJav/00deSz0OClf0HBtlsqQOqUpcIcvXby3c4BOgkcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669505; c=relaxed/simple;
	bh=x6nsc+yXtUJad3HH9b+9zTaosfLf0c9sWSGUlU1IssY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7mEKhCNJvmGVTNH8Y2/3vjEd1RlRQS3HVgfmVE/Qec5R8+omnpmDx0xsZ/CdD5NcEqiDPmn5JAsVdiMZFLZAF4n2BSdZGbz8U11p/Th6h5l9Tb0QSr6UZpww+lUqv2+cSh358+GE1206DWanEHJTyBkDhijMIxHuUOouIq2U7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPkOUWci; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPkOUWci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFA21F00A3F;
	Tue, 21 Jul 2026 21:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669504;
	bh=EdCF8jVhhdhrMmJn8LlCbDoHPQHjIgvtPu4QtGAmQJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPkOUWci2/245lwClrJ19jrg5WWTLxIptF8eKMudugbwM3GDTfLZJ7N5/pb77Ndn2
	 2y+l17RsPInRLwclOAb620riGcnzJUoMqBcmmBPTRG4JMBPOlJcCA+PqHqZqYih/7g
	 rnMTRVUyP9JPUp/dbsvAD73djmQFcsSnx6r3uh1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Zhang Yanmin <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0563/1067] perf tools: Use snprintf() for root_dir path construction
Date: Tue, 21 Jul 2026 17:19:24 +0200
Message-ID: <20260721152437.198405269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

[ Upstream commit 7b0df6f4d498b1608afccfd6dffb264e6da91693 ]

get_kernel_version() in machine.c and dso__load_guest_kernel_sym() in
symbol.c use sprintf() to construct paths by prepending root_dir to
"/proc/version" and "/proc/kallsyms" respectively.  Both write into
PATH_MAX stack buffers, but root_dir comes from --guestmount or KVM
configuration and is not length-checked.  A root_dir at or near
PATH_MAX causes a stack buffer overflow.

Switch to snprintf() with sizeof(path) to prevent overflow.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: a1645ce12adb6c9c ("perf: 'perf kvm' tool for monitoring guest performance from host")
Cc: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 2 +-
 tools/perf/util/symbol.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 9cd52f50ea7acf..419147da8d672b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1443,7 +1443,7 @@ static char *get_kernel_version(const char *root_dir)
 	char *name, *tmp;
 	const char *prefix = "Linux version ";
 
-	sprintf(version, "%s/proc/version", root_dir);
+	snprintf(version, sizeof(version), "%s/proc/version", root_dir);
 	file = fopen(version, "r");
 	if (!file)
 		return NULL;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b434f2398df5ac..bc79eace253591 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2336,7 +2336,7 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map)
 		if (!kallsyms_filename)
 			return -1;
 	} else {
-		sprintf(path, "%s/proc/kallsyms", machine->root_dir);
+		snprintf(path, sizeof(path), "%s/proc/kallsyms", machine->root_dir);
 		kallsyms_filename = path;
 	}
 
-- 
2.53.0



