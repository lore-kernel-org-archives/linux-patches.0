Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2C41F37A1;
	Tue, 12 Aug 2025 19:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026310; cv=none; b=Zk1a3bPULGuvJNQ9sfipk1lxISGRRVjaxMeY3SdJoCOD7GN+3DqvXthx82cd5pGMI0p9wABclfxduOEEZlFnBSBSfuTzaDZW2Mr9JP7dij11RzP4sBkD+m4ayDoC0ndveWyKcUBpDlDYUhAnuhCmnoej950fOmt77ZsARjFl8gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026310; c=relaxed/simple;
	bh=L/784mn5SKStP+4bGjh691qu1bUOIF4khO7kOsbivNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhWpDi85TxtwAxWq2H5rs8d5fl8r8u0crdcqT+FBmdkRq2uNyNwdmEmKPLjAqp5RrG7GPtjB9JuC2CYGbiHrn/6c9hkbGl2xMpdZawtOHeEh/W7O0RU1XQG25a0JwbKl6OodqqmUQwfGqEZ/clYJFeR+yHtG7eboNq+KPPJQKDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxqRa9ru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxqRa9ru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2949C4CEF0;
	Tue, 12 Aug 2025 19:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026310;
	bh=L/784mn5SKStP+4bGjh691qu1bUOIF4khO7kOsbivNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NxqRa9ru53orw6X9OXMIDuhI3J7zWm6FIa0hV5GihlPfIDi+FlyZ7PBXh57kRjTjS
	 TI0XLNuWZ7/wJMW09max9N+oSxg7b+iw1KrS2ZizdVbi+E8Q+CyDaS0sIXwmUTrfeX
	 IYXVSnyFWnpDg0hLOYhzFuydvxiAOJS+3ZFKdwKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 256/480] perf dso: Add missed dso__put to dso__load_kcore
Date: Tue, 12 Aug 2025 19:47:44 +0200
Message-ID: <20250812174408.004681293@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 63a088e999de3f431f87d9a367933da894ddb613 ]

The kcore loading creates a set of list nodes that have reference
counted references to maps of the kcore. The list node freeing in the
success path wasn't releasing the maps, add the missing puts. It is
unclear why this leak was being missed by leak sanitizer.

Fixes: 83720209961f ("perf map: Move map list node into symbol")
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250624190326.2038704-2-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 11540219481b..9c9e28bbb245 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1414,6 +1414,7 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 				goto out_err;
 			}
 		}
+		map__zput(new_node->map);
 		free(new_node);
 	}
 
-- 
2.39.5



