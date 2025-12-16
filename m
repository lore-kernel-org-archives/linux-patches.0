Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4695322527;
	Tue, 16 Dec 2025 12:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887859; cv=none; b=gdYFipQpmTK5+JAkhMJF9oI8wOCdNDkxch+avunQrP6TReets+GeJj3OhcPKU448bPow/iSS+1nz1ymsj4SQ02UDUmzojKFC2js12iRtisT9DeGIRLCxSWZghHnONbUydaBcWB/p/Mt0OwiE7lxR0XDlYpqkzSSHkt35OFEGIrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887859; c=relaxed/simple;
	bh=aW4feubJ6uF/7KfOe3/wJgjz+AyOEcITwprtQ/UunSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dASTpwrxjgx0Fxm83rXl36XSLfn9Fa0Yj2d0qQkmu6WMHf9qUDImBySgzdfEbDfG+4En1XBwGjGT6CXhwhfp107yUYvc6rq9dpTrYxgwMtroZ3cHFRnnOYao8SucDbm/ifYwvu0zoy92r0cJjb5pSDM25xqrpFqpyEVRVlS3e4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFriu64s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFriu64s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DB4C4CEF1;
	Tue, 16 Dec 2025 12:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887859;
	bh=aW4feubJ6uF/7KfOe3/wJgjz+AyOEcITwprtQ/UunSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFriu64sPGnQg3DpIcB//rJMG9Ygvmy68ZiASGOaw96nCEG3qGUxf0NHj1Cafh8W1
	 WpnhMeB384oHwCdBT3w8x8wTvElbY2tUJid5aGr5ZXOSZLLlZx7wVBk5pt0FrzW8pc
	 2XZMIS+W5pI5PZcEQaZi41Ubt9c7cFNM/Mp9fghI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Pravdin <ipravdin.official@gmail.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 360/614] rtla: Fix -a overriding -t argument
Date: Tue, 16 Dec 2025 12:12:07 +0100
Message-ID: <20251216111414.404909470@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Ivan Pravdin <ipravdin.official@gmail.com>

[ Upstream commit ddb6e42494e5c48c17e64f29b7674b9add486a19 ]

When running rtla as

    `rtla <timerlat|osnoise> <top|hist> -t custom_file.txt -a 100`

-a options override trace output filename specified by -t option.
Running the command above will create <timerlat|osnoise>_trace.txt file
instead of custom_file.txt. Fix this by making sure that -a option does
not override trace output filename even if it's passed after trace
output filename is specified.

Fixes: 173a3b014827 ("rtla/timerlat: Add the automatic trace option")
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
Reviewed-by: Tomas Glozar <tglozar@redhat.com>
Link: https://lore.kernel.org/r/b6ae60424050b2c1c8709e18759adead6012b971.1762186418.git.ipravdin.official@gmail.com
[ use capital letter in subject, as required by tracing subsystem ]
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/osnoise_hist.c  | 3 ++-
 tools/tracing/rtla/src/osnoise_top.c   | 3 ++-
 tools/tracing/rtla/src/timerlat_hist.c | 3 ++-
 tools/tracing/rtla/src/timerlat_top.c  | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/tracing/rtla/src/osnoise_hist.c b/tools/tracing/rtla/src/osnoise_hist.c
index dffb6d0a98d7d..d22feb4d6cc9d 100644
--- a/tools/tracing/rtla/src/osnoise_hist.c
+++ b/tools/tracing/rtla/src/osnoise_hist.c
@@ -557,7 +557,8 @@ static struct common_params
 			params->threshold = 1;
 
 			/* set trace */
-			trace_output = "osnoise_trace.txt";
+			if (!trace_output)
+				trace_output = "osnoise_trace.txt";
 
 			break;
 		case 'b':
diff --git a/tools/tracing/rtla/src/osnoise_top.c b/tools/tracing/rtla/src/osnoise_top.c
index 95418f7ecc961..a8d31030c4122 100644
--- a/tools/tracing/rtla/src/osnoise_top.c
+++ b/tools/tracing/rtla/src/osnoise_top.c
@@ -397,7 +397,8 @@ struct common_params *osnoise_top_parse_args(int argc, char **argv)
 			params->threshold = 1;
 
 			/* set trace */
-			trace_output = "osnoise_trace.txt";
+			if (!trace_output)
+				trace_output = "osnoise_trace.txt";
 
 			break;
 		case 'c':
diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index 606c1688057b2..3d56df3d5fa0d 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -878,7 +878,8 @@ static struct common_params
 			params->print_stack = auto_thresh;
 
 			/* set trace */
-			trace_output = "timerlat_trace.txt";
+			if (!trace_output)
+				trace_output = "timerlat_trace.txt";
 
 			break;
 		case 'c':
diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index fc479a0dcb597..6cc9a3607c665 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -628,7 +628,8 @@ static struct common_params
 			params->print_stack = auto_thresh;
 
 			/* set trace */
-			trace_output = "timerlat_trace.txt";
+			if (!trace_output)
+				trace_output = "timerlat_trace.txt";
 
 			break;
 		case '5':
-- 
2.51.0



