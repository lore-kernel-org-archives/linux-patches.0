Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C591A43D4F7;
	Tue, 16 Jun 2026 15:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625263; cv=none; b=j+Jxn0pdi2n5I/pN2xFXZBvlvXaDnu4P/WuWbPWir8VrTSA43WzeHiRxCiIJH2UH1Z7VsCMfudZafQV65Qf5zBYEF/YQd6Srxoi4Qwp6n22Zg9CskdeoEr+iayiXhWv7Pc8g/Lo0KNYgh6W1/4O0hjnEvdK9j9EItZAIADbLxLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625263; c=relaxed/simple;
	bh=5xdRT7hCtoyT+wM5W8B6058XUA+sUZ5iogCIR04/eV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJAkHDGQV+h5jjjKLmBPtNm/eU62hDBqm4lNyhMPENTIXWsPCw2+XE99tL6aWA/04Aq6NUNItzErcYGYQPNo+wARdoVwn3kmz1sLJLPoFhFV9n/bcR6DWgZjjG2lmdtv5HDEVL/VVWYdjRnqbwrQbAQ2JyzAm653D3iADQziJhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=meR+vXCj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="meR+vXCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16EB1F000E9;
	Tue, 16 Jun 2026 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625262;
	bh=lMoVLGy0C/CgX3MdPv+2qWWi4YqEr/01jqzgOy8xwt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=meR+vXCjHTs9NCt9txgeE0/+ukew89M/4g0uoJHRpFdPkVaI9XSpDM+f2ybkXY1nq
	 lN4KXOdQkOxaJTZgT+MAlrJGR5hp9PuIDCx4kOJHyQAM/PmozyqVv85yZLAROx3vWY
	 Dny8aCl/x0Rc7Nb+jS/PoBEP5HtyawiRNdvpUAds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/325] tools/rv: Fix substring match when listing container monitors
Date: Tue, 16 Jun 2026 20:27:57 +0530
Message-ID: <20260616145101.763159970@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit ba0247c5aa3fcb2890a92a97a88c70fe5ce704a6 ]

When listing monitors within a specific container (rv list <container>),
the tool incorrectly matched monitors if the requested container name
was only a prefix of the actual container (e.g., 'rv list sche' would
incorrectly list monitors from 'sched:').

Fix this by ensuring the container name is an exact match and is
immediately followed by the ':' separator.

Fixes: eba321a16fc6 ("tools/rv: Add support for nested monitors")
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/r/20260514152055.229162-3-gmonaco@redhat.com
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/verification/rv/src/in_kernel.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/verification/rv/src/in_kernel.c b/tools/verification/rv/src/in_kernel.c
index 95eac9ab148468..e4f35940374f5a 100644
--- a/tools/verification/rv/src/in_kernel.c
+++ b/tools/verification/rv/src/in_kernel.c
@@ -193,8 +193,12 @@ static int ikm_fill_monitor_definition(char *name, struct monitor *ikm, char *co
 	nested_name = strstr(name, ":");
 	if (nested_name) {
 		/* it belongs in container if it starts with "container:" */
-		if (container && strstr(name, container) != name)
-			return 1;
+		if (container) {
+			int len = strlen(container);
+
+			if (strncmp(name, container, len) || name[len] != ':')
+				return 1;
+		}
 		*nested_name = '/';
 		++nested_name;
 		ikm->nested = 1;
-- 
2.53.0



