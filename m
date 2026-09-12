Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE723803C3;
	Sat, 12 Sep 2026 08:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201103; cv=none; b=Rz9nyd1zGqzxmC1XiHcnDz1Mn2VOOh2TH1WnAa/iQmfuMWEbZ7hYRcukQpNIur8XnibIGcUpEUihNuiMg/Z94xNwIw0DeJTnY61wwZNrkhJw1XlZ9ljsaSfPot3ds++3d1x5pUMcLRxvwe9PJERv9PWmFZ3JhhAgVrZw+8Htk64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201103; c=relaxed/simple;
	bh=aUPb4hDq4S8xC5NkkLjHv4zyxsDH32EuICl/KMWvKF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UwJSOKCRIy13k7f3YOfWtjPDFvayXE1dC2bGyk8bOQy1/11DnMyTScuM6WU6gnkdTaeCGKc35UHy0E+PHJaA8TMjJKO0AUJNuvj30KsNvLTJDrqmFjf90KzKvauUuq9+g6zsvbZUrwqzR60PcliIhOIHzejuwR/T7CccTHd9Weg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8k8n/4s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8k8n/4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2DD1F000FF;
	Sat, 12 Sep 2026 08:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201102;
	bh=Hve3cRnwSf3bQxc4Qlhcdb5dWiqR1CvklAs7y8RNoLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8k8n/4ssQilzhYz1nOxT18uE4hDEL8abLEKiXBLqJScA2QuHL6w1DurByj5DI4/v
	 NzvEhDriSuBNwXdCkmZs+qCn+/LFYCe0W2FSXCEQIxMTwkevxC89wYlqrwznA/Y+yK
	 IFJcii9foVAyneyi4rrEi5Z6/bRRdqPxbNWclN2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0928/1815] perf machine: Dont abort guest map creation on first inaccessible dir
Date: Sat, 12 Sep 2026 08:44:38 +0200
Message-ID: <20260912065710.732077561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit b687e1a418fb819ef83c362d84c216a6a841e3b0 ]

machines__create_guest_kernel_maps() jumps to the failure label when one
guest directory's kallsyms file fails access(), skipping all remaining
valid guest directories.  An inaccessible directory is not fatal — other
guests may still be reachable.

Replace 'goto failure' with 'continue' so the loop processes all
directories, and remove the now-unreferenced failure label.

Fixes: a1645ce12adb ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 05724277c2a97..83d38637afe34 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1269,14 +1269,12 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 			snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
 				 symbol_conf.guestmount,
 				 namelist[i]->d_name);
-			ret = access(path, R_OK);
-			if (ret) {
+			if (access(path, R_OK)) {
 				pr_debug("Can't access file %s\n", path);
-				goto failure;
+				continue;
 			}
 			machines__create_kernel_maps(machines, pid);
 		}
-failure:
 		free(namelist);
 	}
 
-- 
2.53.0



