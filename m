Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09DCFBE1;
	Mon, 11 Dec 2023 18:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvZ4esd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C011C433C7;
	Mon, 11 Dec 2023 18:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319790;
	bh=GEgjwz7Iljh3R9lCjpWtOutxQ6vlK2z+cr6Xgt5jDb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvZ4esd76vcknMnHVXr9xmEekC7H79XDZOS074ucK+yL/5SKzT9BIqMDyj28O4bY0
	 84dQD8zkiHJxWU8mSWUF7/dAZF5LTHrrJ5mvG42EXWSzpG8/1CTiMhPuBeKStLR4Y5
	 i3wLhO38tua7hPbyoBn8XTsWjzG69Ko3HiX9kMJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.6 233/244] perf list: Fix JSON segfault by setting the used skip_duplicate_pmus callback
Date: Mon, 11 Dec 2023 19:22:06 +0100
Message-ID: <20231211182056.484594136@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

commit b1693747487442984050eb0f462b83a3a8307525 upstream.

Json output didn't set the skip_duplicate_pmus callback yielding a
segfault.

Fixes: cd4e1efbbc40 ("perf pmus: Skip duplicate PMUs and don't print list suffix by default")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@arm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231129213428.2227448-2-irogers@google.com
[namhyung: updated subject line according to Arnaldo]
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-list.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index a343823c8ddf..61c2c96cc070 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -434,6 +434,11 @@ static void json_print_metric(void *ps __maybe_unused, const char *group,
 	strbuf_release(&buf);
 }
 
+static bool json_skip_duplicate_pmus(void *ps __maybe_unused)
+{
+	return false;
+}
+
 static bool default_skip_duplicate_pmus(void *ps)
 {
 	struct print_state *print_state = ps;
@@ -503,6 +508,7 @@ int cmd_list(int argc, const char **argv)
 			.print_end = json_print_end,
 			.print_event = json_print_event,
 			.print_metric = json_print_metric,
+			.skip_duplicate_pmus = json_skip_duplicate_pmus,
 		};
 		ps = &json_ps;
 	} else {
-- 
2.43.0



