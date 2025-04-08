Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72595263C90;
	Tue,  8 Apr 2025 11:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111515; cv=none; b=lpbrD0dQ6e3R9nFC9Dab4IqVzoh/2cleDFC2XDeScbSHNjbf34OG/PKkfxAj4TDl9z2iiZlTdf3hhNTCctv1iwEBhdG84pghw0IOpXxjn/KUjb71l/oXYObDMuHD0RaBnHVKYfNmJVKGemg8W6UY5iu73/7ICx3HXfxkdhNBVUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111515; c=relaxed/simple;
	bh=Y1KA0+4iVouiIM0w5z+QKgSK7+EJsEsmE0cPNvWQi/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HApSlsy66jj6WDWAnWoATHCo88IXlFMpaDEGejVcFR979VH5+ZQg8EafFxJRr/LiQAMTN1wZgpYxeKPhsE62hD9ECnEvVmddrlImp0Jx0t2SE41Q45aBTvyF+jz1S3PigIHr94qhp4CMthIpiesEoSLN5oGt0gPijK5SyU4HPYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbcOYzY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbcOYzY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF791C4CEE5;
	Tue,  8 Apr 2025 11:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111515;
	bh=Y1KA0+4iVouiIM0w5z+QKgSK7+EJsEsmE0cPNvWQi/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbcOYzY7V5eXZhrpE9S7SRC51UXZ5bmS0mqTxup6rvKIKweos6oCEfxO1VRqRDINE
	 SjG5hvL2FS+p4hLh8orhw/JVUX+5+yCOm2OpK2WQkhdWENRZRCX2ukdnYim2Wz5RXV
	 rwaU6LFmioF2H74v/OuF1fT1o2r0EY0dfk7absLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 458/731] perf report: Switch data file correctly in TUI
Date: Tue,  8 Apr 2025 12:45:55 +0200
Message-ID: <20250408104924.932431529@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 43c2b6139b188d8a756130147f7efd5ddf99f88d ]

The 's' key is to switch to a new data file and load the data in the
same window.  The switch_data_file() will show a popup menu to select
which data file user wants and update the 'input_name' global variable.

But in the cmd_report(), it didn't update the data.path using the new
'input_name' and keep usng the old file.  This is fairly an old bug and
I assume people don't use this feature much. :)

Link: https://lore.kernel.org/r/20250211060745.294289-1-namhyung@kernel.org
Closes: https://lore.kernel.org/linux-perf-users/89e678bc-f0af-4929-a8a6-a2666f1294a4@linaro.org
Fixes: f5fc14124c5cefdd ("perf tools: Add data object to handle perf data file")
Reported-by: James Clark <james.clark@linaro.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f5fbd670d619a..c99b14a852dbd 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1553,12 +1553,12 @@ int cmd_report(int argc, const char **argv)
 			input_name = "perf.data";
 	}
 
+repeat:
 	data.path  = input_name;
 	data.force = symbol_conf.force;
 
 	symbol_conf.skip_empty = report.skip_empty;
 
-repeat:
 	perf_tool__init(&report.tool, ordered_events);
 	report.tool.sample		 = process_sample_event;
 	report.tool.mmap		 = perf_event__process_mmap;
-- 
2.39.5



