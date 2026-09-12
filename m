Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A521C5799;
	Sat, 12 Sep 2026 18:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239407; cv=none; b=OXmqymDafZ1TZ379UBh9kgajqFCAAtjxitIgi+aZj9UgoVt5WMdCOXEsRPMaxAgpEzYZfuBa40VEFjmEpBLZ3SQl+sCI+I4UguS2cEDFFQxQVRQC2qDKeMMD/gqW48WnpGkpauu9REy749lbcDt+mjk3mlNcjlJ8wCmfkdjZoMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239407; c=relaxed/simple;
	bh=iSpJaqWel+w1sbpNkWWB5MNKWxXhdXlFFJv7MsXs+Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pb6uTZrArqDJftMQdFHiJ+4dkvhTF20yNcoh0zYPJJB/4MSPuk9yuZMFvr0wMiJSVWmiVFl/tmBNCnzJ/eDf0UPdV31CYYGn0ZcS7mZsK+KOhKgBtt66T8ZOxLZ1Txdl6vuN+Dw7a5e9MTnzf+SZ5gGQXSxnH+CuZNtNXjlyD18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byZX92Cm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byZX92Cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0061F000FF;
	Sat, 12 Sep 2026 18:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239406;
	bh=QU1ba/S87jiV4X8gVXQrs1oO2U2dn3H+jr1LA48EOEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=byZX92Cm8EJ5R9K9WBz6e8LNFJzfpCNwYvJXAwwMqJvpxacI/i6q5Os5o83u+LkNI
	 d2zz2KLZP2Q1RFG+wks5CJxuZP1WR6sfPrgK4LSVMeGLFC4ZYw0ZnPdLukAEhOf1Om
	 FSuhFLyL7is/+5buK7NGkZmvLgG5xWAM7s/apzQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 657/935] perf machine: Dont abort guest map creation on first inaccessible dir
Date: Sat, 12 Sep 2026 09:01:27 +0200
Message-ID: <20260912065541.911378428@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3fa2975a64ae1..a1c51c50b9022 100644
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



