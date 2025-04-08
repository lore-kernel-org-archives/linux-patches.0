Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ABE26981F;
	Tue,  8 Apr 2025 12:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114741; cv=none; b=sbwo2TI9lqRaG9BIL/cBRQnrGy7MDQRhrJbMP/V+JhNes/HcN2C9Zp6fkic1fYc+yrEzhdbvtbGO5t5NRarbSm0C619LkUEJh2RVDJPDMHcVPpzKXkXiGc+pVCxb6xRaNOHmdUXe7UDd7hvQRnUJu0uxcSjrbzp1FYyNcxmTOVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114741; c=relaxed/simple;
	bh=t2ofxJxauHn2TBeyKiBl3lnLJbCHaB/QMbIEu9G5NhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpsZuNQup67DQOq0+yPWZHZKdCxOULD2h0c7vyOQsI+NYSMJiTMdgpJyDvJRlCgl1F1rQ5tvphnJG412rjvpMJN8eiYM0gaMvZUEgLxu+Hb2jU9ui+sC/ZfqLKD1AiEZdXnHw2gv9RIL7D16ynJdpGrwNPEgZl6kykxYfP3teMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saTxJP09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saTxJP09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F16C4CEE5;
	Tue,  8 Apr 2025 12:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114740;
	bh=t2ofxJxauHn2TBeyKiBl3lnLJbCHaB/QMbIEu9G5NhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=saTxJP099frJxRNo/nuwx/wuTvpTvHT7MuWC4XLlCa9IX9OK33r9W/qAZndR0MOuv
	 +3aU8iH7rUTAo93hcQoomi1oThwxImMXjCK1GmZNyb7pNbtoo5OVVNd/tE6/DLp6mf
	 CKFU+6FjoFq93G8/FhLEFLwGCvrJEQMF2O0zHSbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 219/499] perf build: Fix in-tree build due to symbolic link
Date: Tue,  8 Apr 2025 12:47:11 +0200
Message-ID: <20250408104856.670180702@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit 75100d848ef4b8ca39bb6dd3a21181e37dea27e2 ]

Building perf in-tree is broken after commit 890a1961c812 ("perf tools:
Create source symlink in perf object dir") which added a 'source' symlink
in the output dir pointing to the source dir.

With in-tree builds, the added 'SOURCE = ...' line is executed multiple
times (I observed 2 during the build plus 2 during installation). This is a
minor inefficiency, in theory not harmful because symlink creation is
assumed to be idempotent. But it is not.

Considering with in-tree builds:

  srctree=/absolute/path/to/linux
   OUTPUT=/absolute/path/to/linux/tools/perf

here's what happens:

 1. ln -sf $(srctree)/tools/perf $(OUTPUT)/source
    -> creates /absolute/path/to/linux/tools/perf/source
       link to /absolute/path/to/linux/tools/perf
    => OK, that's what was intended
 2. ln -sf $(srctree)/tools/perf $(OUTPUT)/source   # same command as 1
    -> creates /absolute/path/to/linux/tools/perf/perf
       link to /absolute/path/to/linux/tools/perf
    => Not what was intended, not idempotent
 3. Now the build _should_ create the 'perf' executable, but it fails

The reason is the tricky 'ln' command line. At the first invocation 'ln'
uses the 1st form:

       ln [OPTION]... [-T] TARGET LINK_NAME

and creates a link to TARGET *called LINK_NAME*.

At the second invocation $(OUTPUT)/source exists, so 'ln' uses the 3rd
form:

       ln [OPTION]... TARGET... DIRECTORY

and creates a link to TARGET *called TARGET* inside DIRECTORY.

Fix by adding -n/--no-dereference to "treat LINK_NAME as a normal file
if it is a symbolic link to a directory", as the manpage says.

Closes: https://lore.kernel.org/all/20241125182506.38af9907@booty/
Fixes: 890a1961c812 ("perf tools: Create source symlink in perf object dir")
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20250124-perf-fix-intree-build-v1-1-485dd7a855e4@bootlin.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.perf | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index d74241a151313..37a6a36cb70c8 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -164,7 +164,7 @@ ifneq ($(OUTPUT),)
 VPATH += $(OUTPUT)
 export VPATH
 # create symlink to the original source
-SOURCE := $(shell ln -sf $(srctree)/tools/perf $(OUTPUT)/source)
+SOURCE := $(shell ln -sfn $(srctree)/tools/perf $(OUTPUT)/source)
 endif
 
 ifeq ($(V),1)
-- 
2.39.5



