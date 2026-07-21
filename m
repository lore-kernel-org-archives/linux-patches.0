Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E9E46F4A1;
	Tue, 21 Jul 2026 19:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660680; cv=none; b=ZV0ZOgng/Vio0BabzyPDJcLANP8BWhJzoIgnErqzVx2+paEYVQs+v12POfctOh+JsMDQG0GHClJ0TAWnuHz4/t9UiZyIZt1et0MgunhXr0QQg8mk4X0XjQwZ3dgC/cq46xQS1ZmNUq0Dps2jGFQH6L6HtwzAvzf0uNnj5wLDE34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660680; c=relaxed/simple;
	bh=xeeUIU23KSonSKSC1JoNRjfbGKypzq/MDeHZ6tS/XBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDqwLguqlTBJhqWUA8Nm345t6RDdAkoX87Y8PduZ/L5thjkkvpPVsza2ETnssovXW8Z30KzOcmXeHUA1Y/zm1jlImDyWbENgimr5j1hHJdVvcgo/Thpvd7ObWDKYmXyuGG5LRE2zMz7qVD1fj37XnAlhPejb097zZGsYpsbLUJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYGSteKm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYGSteKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C040B1F000E9;
	Tue, 21 Jul 2026 19:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660679;
	bh=HjQAyY3xK8Q+Wg4INeeCqhWgmGm+AzL4QC0JLJAzI7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYGSteKmj+K7GP/jr21BCBs00Js5CdqbDa3yxiMt8iCyZwzItGUqQ3CVHLkyZVbLv
	 RPwBLqhRhMxD/Q9PrR1zSFKjskBa+QFGVuvKimvSi9bq0fzZN1RehysJ4w/bO8pdoN
	 l6TF85Pac13w50kx8TVFUEzIeq1Ke8PiX3kJjZ0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1072/2077] perf dso: Fix heap overflow in dso__get_filename() on decompressed path
Date: Tue, 21 Jul 2026 17:12:25 +0200
Message-ID: <20260721152618.108064513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit f973e52a99776fcc473488984828d1fce56d5382 ]

dso__get_filename() allocates name with malloc(PATH_MAX), but the
dso__filename_with_chroot() path replaces name with an asprintf'd
exact-size string (e.g. 8 bytes for "/a/b.ko").  When the DSO needs
decompression, dso__decompress_kmodule_path() writes the temp path
("/tmp/perf-kmod-XXXXXX", 22 bytes) into newpath, and strcpy(name,
newpath) overflows the smaller allocation.

Replace the strcpy with strdup(newpath) + free(name) so the buffer
is always correctly sized for its content.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 1d6b3c9ba756a513 ("perf tools: Decompress kernel module when reading DSO data")
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 7200722464e719..e896e6da81e96c 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -603,8 +603,15 @@ static char *dso__get_filename(struct dso *dso, const char *root_dir,
 
 		/* empty pathname means file wasn't actually compressed */
 		if (newpath[0] != '\0') {
+			char *tmp = strdup(newpath);
+
+			if (!tmp) {
+				unlink(newpath);
+				goto out;
+			}
+			free(name);
+			name = tmp;
 			*decomp = true;
-			strcpy(name, newpath);
 		}
 	}
 	return name;
-- 
2.53.0



