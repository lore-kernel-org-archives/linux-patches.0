Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833881A6161;
	Tue, 30 Jul 2024 16:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356118; cv=none; b=UKNp1H6AaVfsYRNKT1yBOVYVBIU0h4M7yfhSvWOCZdZYHJAWx5g3HwqgWzzwJmu5TieZmHTDfY5gl3Tg+cUAOcpGQYhEk0XFZypYl6DnYjulDgtnZIWkawH1ynZTjsYUNYYenj1pnCtn7oVDNRbLWy6rM85N64O7Gj2cDX7R4M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356118; c=relaxed/simple;
	bh=Yc0i+YNDdSzDYuM3ZOr6qks0c9Mv4Z2i82DMrfdTSjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RcShWh6l2P4lhVd5oxMia5BmVAcjX3WcjPavnA8azovoU9W06XU6lhIaS+G9txItHhUegC1/Qw7r+S4atKHpZhWPsnOBrDxDlhaXNEsczH3QDkAWJuqV9JmZ82PR5d+7cFK8DqlWoeZfLilz79mJHO0Glq/9fSTNY2Htjb9Lfnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBHQlpfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBHQlpfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DC4C32782;
	Tue, 30 Jul 2024 16:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356118;
	bh=Yc0i+YNDdSzDYuM3ZOr6qks0c9Mv4Z2i82DMrfdTSjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBHQlpfenaQm1LioZNT+agGBfAPz5sL8+MSCDYFTVkHrkKLsb1B0J+CVhDC2JF4r0
	 0u79u39V6X9dqj+n2QpXryZ4ReTB8gH9vEUzzjaZvvUwhC1KV0GYEup8CF1fNqvgmr
	 mRQ/tPcqtwpOjc7M4Jpta9sneKo2TZlVOTl++mkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Spoorthy S <spoorts2@in.ibm.com>,
	Disha Goel <disgoel@linux.vnet.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	linuxppc-dev@lists.ozlabs.org,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/440] perf tests arm_callgraph_fp: Address shellcheck warnings about signal names and adding double quotes for expression
Date: Tue, 30 Jul 2024 17:46:30 +0200
Message-ID: <20240730151622.009115670@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Spoorthy S <spoorts2@in.ibm.com>

[ Upstream commit 1bb17b4c6c91ad4d9468247cf5f5464fa6440668 ]

Running shellcheck -S on test_arm_calligraph_fp throws warnings SC2086 and SC3049,

      $shellcheck -S warning tests/shell/test_arm_callgraph_fp.sh
         rm -f $PERF_DATA
            : Double quote to prevent globbing and word splitting.
         trap cleanup_files exit term int
                     : In POSIX sh, using lower/mixed case for signal names is undefined.

After fixing the warnings,

      $shellcheck tests/shell/test_arm_callgraph_fp.sh
      $ echo $?
      0

To address the POSIX shell warnings added changes to convert Lowercase
signal names to uppercase in the script and double quoted the
command substitutions($fix to "$fix") to solve Globbing warnings.

Signed-off-by: Spoorthy S<spoorts2@in.ibm.com>
Cc: Disha Goel <disgoel@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: https://lore.kernel.org/r/20230613164145.50488-4-atrajeev@linux.vnet.ibm.com
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: ff16aeb9b834 ("perf test: Make test_arm_callgraph_fp.sh more robust")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_arm_callgraph_fp.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/tests/shell/test_arm_callgraph_fp.sh b/tools/perf/tests/shell/test_arm_callgraph_fp.sh
index e61d8deaa0c41..1380e0d12dce3 100755
--- a/tools/perf/tests/shell/test_arm_callgraph_fp.sh
+++ b/tools/perf/tests/shell/test_arm_callgraph_fp.sh
@@ -9,13 +9,13 @@ TEST_PROGRAM="perf test -w leafloop"
 
 cleanup_files()
 {
-	rm -f $PERF_DATA
+	rm -f "$PERF_DATA"
 }
 
-trap cleanup_files exit term int
+trap cleanup_files EXIT TERM INT
 
 # Add a 1 second delay to skip samples that are not in the leaf() function
-perf record -o $PERF_DATA --call-graph fp -e cycles//u -D 1000 --user-callchains -- $TEST_PROGRAM 2> /dev/null &
+perf record -o "$PERF_DATA" --call-graph fp -e cycles//u -D 1000 --user-callchains -- "$TEST_PROGRAM" 2> /dev/null &
 PID=$!
 
 echo " + Recording (PID=$PID)..."
-- 
2.43.0



