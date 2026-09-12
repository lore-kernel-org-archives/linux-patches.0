Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270AF1C5799;
	Sat, 12 Sep 2026 18:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239412; cv=none; b=Pq9vVlDqzZg8GWpagcWmaHgCJJ5O6Kt2gL3FCF1nG8sLvyNK4jhcI7gQDJqaZHiRuIIYI/jgnXdR641xDNx+vIOBpJjyGqhMo54U8Z7B7oGwyO1DefqGEuKgDeZu0vaxINmv0YHEnC2G7MEChlut6ytfQfMt8T2sMjAKa2MjlDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239412; c=relaxed/simple;
	bh=Fio0IMFvtG74uMvB3MP34O1vQNV/ef9Fx1caon8WIB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kl77Vz7q3UdT8o7QDZl/9/3cYM9D76ujejzxdhh6vjDsrZD8EhHOQRETjUFhn0CzDViJ9Bvs4Ln13YP4k5x45Ofza3LfYZ4IOnvtgldTDDC9STfN3h1Iq/5xZyU3e2+reqhF/8F4Vbs81Ga+Q/B9JwXLClp3pF3aj4L5XqLlOMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujXGd1NQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujXGd1NQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A761F000FF;
	Sat, 12 Sep 2026 18:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239411;
	bh=3H/yMsFc+aoRy7r+4vrL9K4FAD6iMEeLDY79NoFowlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ujXGd1NQa0AOvozbNLuvKaAPwu1GTqureeDbPGZfbEgqnZ0j0zMi8DgIcLUFFeOPl
	 J5ekrgK0k4Qx2e0LsRa8FWfCkZAbXcC9M93qvTYkBAbCSaWupZMFHYIF4Tr5ievP1U
	 UiQ5Vfs7Dj0GRKjwKsqIJUueXkdGYckYxfljjbcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 658/935] perf machine: Reset errno before strtol in guest kernel map creation
Date: Sat, 12 Sep 2026 09:01:28 +0200
Message-ID: <20260912065541.933293382@linuxfoundation.org>
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

[ Upstream commit 29ec46e43f6ca7d6a6651db724d4ffd820f46e8b ]

machines__create_guest_kernel_maps() checks errno == ERANGE after
strtol() to detect overflow, but does not clear errno first.  A stale
ERANGE from an earlier library call (e.g. scandir internals) causes
valid numeric directory names to be incorrectly skipped.

Set errno = 0 before strtol() so only the current conversion can
trigger the ERANGE check.

Fixes: a1645ce12adb ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index a1c51c50b9022..15ac6e16fd47d 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1258,6 +1258,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 				/* Filter out . and .. */
 				continue;
 			}
+			errno = 0;
 			pid = (pid_t)strtol(namelist[i]->d_name, &endp, 10);
 			if ((*endp != '\0') ||
 			    (endp == namelist[i]->d_name) ||
-- 
2.53.0



