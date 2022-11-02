Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF0D7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA75C433D6;
	Wed,  2 Nov 2022 03:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358816;
	bh=xOQh+c+ngSHVsi3g1FK4lnQE1fFsqapkctV5NEJa9oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHOwJDpWjvhBsJDgJD1apRNKzEwva4zxZDWy77O//Mfc7mxMQyibGTnpoK2BQ3rDj
	 M8XOrZRAGqo7Uayj2POHqrzWLbLMQlv1I0bOhcygHDn7g7blY6vLxXcoBdZYJ7/Bpg
	 BjovGVLs8zaqEmknY+1tKFZWT+GY4uRRC1AQaJ3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 29/91] perf auxtrace: Fix address filter symbol name match for modules
Date: Wed,  2 Nov 2022 03:33:12 +0100
Message-Id: <20221102022055.873199663@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adrian Hunter <adrian.hunter@intel.com>

commit cba04f3136b658583adb191556f99d087589c1cc upstream.

For modules, names from kallsyms__parse() contain the module name which
meant that module symbols did not match exactly by name.

Fix by matching the name string up to the separating tab character.

Fixes: 1b36c03e356936d6 ("perf record: Add support for using symbols in address filters")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221026072736.2982-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/auxtrace.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -2164,11 +2164,19 @@ struct sym_args {
 	bool		near;
 };
 
+static bool kern_sym_name_match(const char *kname, const char *name)
+{
+	size_t n = strlen(name);
+
+	return !strcmp(kname, name) ||
+	       (!strncmp(kname, name, n) && kname[n] == '\t');
+}
+
 static bool kern_sym_match(struct sym_args *args, const char *name, char type)
 {
 	/* A function with the same name, and global or the n'th found or any */
 	return kallsyms__is_function(type) &&
-	       !strcmp(name, args->name) &&
+	       kern_sym_name_match(name, args->name) &&
 	       ((args->global && isupper(type)) ||
 		(args->selected && ++(args->cnt) == args->idx) ||
 		(!args->global && !args->selected));


