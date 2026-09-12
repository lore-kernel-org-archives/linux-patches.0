Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3971C5799;
	Sat, 12 Sep 2026 18:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239423; cv=none; b=kYXC7Rrx9blUW6muermFFeAqxXgehWxZ58B/tW+J3s4plK2AymFBs07WbQUVyIxbDoXg++7nop7w0Kqy7D3uVu+BClXz14aKqmuyC4Gwz3Bf/ZBTXP/W3LPIVPtVTyXnpjA2HbjLk1wq0HerF864KePNoUKrX2z2bHOMASQmd7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239423; c=relaxed/simple;
	bh=f85YzsHUJ/YOdeefBX9UsbAY0U3YnWXX6BNqqMRKp1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgDwJ3EDjS6jiir5HCxlWiRWN0IuZeunb0oQWA0JZvgJ8iAyJMfit6RcS9yE5nUfwMNwT6QCtDOtez/j2nZuffKFPb0gObK1jOZ29itsamlTULIOpByRfKWFgDWw1l0Yj42iKBsgQ2pLkgs/5nXkDtnA/lMIzabRZyfyqF2pCtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3puhuLB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3puhuLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8BE1F000FF;
	Sat, 12 Sep 2026 18:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239421;
	bh=32dN/g0vtw5MyB++GEYVhrDrM+ef0rO7QGixHk5lQlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E3puhuLB0UqBh72Ij34VNGmAhOPtUHCcfO5HTmb9O3txPLD9UU2pAbkcEwfDZyYEU
	 J4yu2PWfXUWXL0pOdDgGIj7ozXkFiuEJR2JiVSZ5mzmeRDNY9QReIiskS1rv8c7mSz
	 kwYKTJlQHMzgu71MlJIPqN+2SZZ9mYcVYfOOps5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 660/935] perf machine: Check snprintf truncation for guest kallsyms path
Date: Sat, 12 Sep 2026 09:01:30 +0200
Message-ID: <20260912065541.979380327@linuxfoundation.org>
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
index 59cc45c6d0412..8fbba3616da9b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1269,9 +1269,14 @@ int machines__create_guest_kernel_maps(struct machines *machines)
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



